require 'test_helper'

class Invoice::BulkUploadTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "attaching file" do
    bulk_upload = create_invoice_bulk_upload(file: 'valid_upload.csv')

    assert bulk_upload.file.attached?
  end

  test "enqueue job for processing in background" do
    clear_enqueued_jobs

    bulk_upload = create_invoice_bulk_upload(file: 'valid_upload.csv')

    assert_enqueued_jobs 0
    bulk_upload.process
    assert_enqueued_jobs 1
  end

  test "processing inline valid upload" do
    bulk_upload = create_invoice_bulk_upload(file: 'valid_upload.csv')

    bulk_upload._process

    assert_equal 3, bulk_upload.processed
  end

  test "processing inline invalid upload" do
    bulk_upload = create_invoice_bulk_upload(file: 'invalid_upload.csv')

    bulk_upload._process

    assert_equal 3, bulk_upload.failures
  end

  test "processing inline partiality invalid upload" do
    bulk_upload = create_invoice_bulk_upload(file: 'partiality_invalid_upload.csv')

    bulk_upload._process

    assert_equal 2, bulk_upload.failures
    assert_equal 1, bulk_upload.processed
  end

  private

    def create_invoice_bulk_upload(file: )
      file_path   = Rails.root.join(*%W(test fixtures files #{file}))
      bulk_upload = Invoice::BulkUpload.new

      bulk_upload.file.attach(
        {
          io: File.open(file_path),
          filename: file_path.basename,
          content_type: 'application/csv'
        }
      )
      bulk_upload
    end
end
