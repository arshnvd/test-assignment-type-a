class Invoice
  class BulkUploadsController < ApplicationController
    def index
      @bulk_uploads = BulkUpload.ordered.paginated(params[:page])
    end

    def show
      @bulk_upload = BulkUpload.with_attached_file.find(params[:id])
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