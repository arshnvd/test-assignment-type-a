class Invoice::BulkUpload < ApplicationRecord
  store :report, accessors: %i(messages progress total processed failures), coder: JSON

  has_one_attached :file

  enum status: %i(uploaded processing processed)

  after_create :process

  def self.table_name_prefix
    'invoice_'
  end

  def process
    ProcessingJob.perform_later(id)
  end

  def _process
    temporary_file do |temp_file|
      failures  = 0
      errors    = []
      options   = { headers: true, encoding: 'ISO-8859-1' }
      csv       = CSV.foreach(temp_file.path, **options)
      total     = csv.count

      start_processing!(total)

      csv.with_index(2) do |row, i|
        iid, amount, due_at  = row.fields
        invoice             = Invoice.new(iid: iid, amount: amount, due_at: due_at)

        calculate_progress(total, i)

        next if invoice.save

        failures +=1
        errors << "Line #{i} - #{invoice.errors.full_messages.join(',')}"
      end

      report = { messages: errors, total: total, failures: failures, processed: (total - failures) }

      complete_processing!(report)
    end
  end

  private

    def temporary_file
      _file_ = Tempfile.new
      _file_.write(file.download)
      _file_.rewind

      yield _file_
    ensure
      _file_.close
      _file_.unlink
    end

    def start_processing!(total)
      update(status: :processing)

      ActiveSupport::Notifications.instrument(
        'invoice.bulk_upload.processing.start', { id: id, total: total }
      )
    end

    def complete_processing!(report)
      update(status: :processed, report: report)

      ActiveSupport::Notifications.instrument(
        'invoice.bulk_upload.processing.complete', { id: id, report: report }
      )
    end

    def calculate_progress(total, current)
      progress = (100 / (total.to_f / current))

      instrument_progress?(current) && instrument_progress(progress)
    end

    def instrument_progress?(current)
      # Instrument progress on every 10th record
      (current % 10).zero?
    end

    def instrument_progress(progress)
      ActiveSupport::Notifications.instrument(
        'invoice.bulk_upload.processing.progress', { id: id, progress: progress }
      )
    end
end
