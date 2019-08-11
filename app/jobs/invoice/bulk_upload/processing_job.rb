class Invoice::BulkUpload::ProcessingJob < ApplicationJob
  def perform(id)
    BulkUpload.find(id).process
  end
end