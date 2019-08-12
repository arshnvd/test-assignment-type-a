class Invoice
  class BulkUpload::ProcessingJob < ApplicationJob
    def perform(id)
      BulkUpload.find(id)._process
    end
  end
end