class Invoice
  class BulkUploadsController < ApplicationController
    def index
      @bulk_uploads = BulkUpload.with_attached_file.paginate(page: params[:page], per_page: 10)
    end

    def show
      @bulk_upload = BulkUpload.find(params[:id])
    end

    def new
      @bulk_upload = BulkUpload.new
    end

    def create
      @bulk_upload = BulkUpload.new(bulk_upload_params)
      render :new unless @bulk_upload.save
    end

    private

      def bulk_upload_params
        params.require(:invoice_bulk_upload).permit(:file)
      end
  end
end