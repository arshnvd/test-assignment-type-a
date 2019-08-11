class CreateInvoiceBulkUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_bulk_uploads do |t|
      t.integer :status
      t.jsonb :report

      t.timestamps
    end
  end
end
