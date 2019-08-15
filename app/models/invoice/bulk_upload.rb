class Invoice::BulkUpload < ApplicationRecord
  store :report, accessors: %i(messages progress total processed failures), coder: JSON

  has_one_attached :file

  enum status: %i(uploaded processing processed)

  after_create_commit :process

  def self.table_name_prefix
    'invoice_'
  end

  def process
    ProcessingJob.perform_later(id)
  end

  def _process
    temporary_file do |temp_file|
      failures  = 0
      @_errors    = []
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
        @_errors << "Line #{i} - #{invoice.errors.full_messages.join(',')}"
      end

      report = { messages: @_errors, total: total, failures: failures, processed: (total - failures) }

      complete_processing!(report)
    end
  end

  def uid
    to_gid.to_s
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

      broadcast(uid: uid, action: status, total: total)
    end

    def complete_processing!(report)
      update(status: :processed, report: report)

      broadcast(uid: uid, action: status, report: report)
    end

    def calculate_progress(total, current)
      progress = (100 / (total.to_f / current))

      broadcast_progress?(current) && broadcast_progress(progress)
    end

    def broadcast_progress?(current)
      # Broadcast progress on every 10th record
      (current % 10).zero?
    end

    def broadcast_progress(progress)
      broadcast(uid: uid, action: :progress, progress: progress, errors: @_errors)
    end

    def broadcast(options)
      ActionCable.server.broadcast("notifications:#{uid}", **options)
    end
end
