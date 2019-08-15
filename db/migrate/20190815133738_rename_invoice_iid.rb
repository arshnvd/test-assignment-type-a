class RenameInvoiceIid < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoices, :iid, :internal_id
  end
end
