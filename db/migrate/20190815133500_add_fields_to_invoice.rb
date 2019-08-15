class AddFieldsToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :selling_price, :decimal, default: 0.0
  end
end
