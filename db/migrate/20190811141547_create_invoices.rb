class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :iid
      t.decimal :amount
      t.datetime :due_at

      t.timestamps
    end
  end
end
