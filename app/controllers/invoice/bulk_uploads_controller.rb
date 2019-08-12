class Invoice
  class BulkUploadsController < ApplicationController
    def new
      @bulk_upload = BulkUpload.new
    end

    def create
      @bulk_upload = BulkUpload.new(bulk_upload_params)
      @bulk_upload.save
      puts '-' * 100
      puts @bulk_upload.as_json
      puts '-' * 100
    end

    private

      def bulk_upload_params
        params.require(:invoice_bulk_upload).permit(:file)
      end
  end
end