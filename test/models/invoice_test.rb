require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test "invalid without iid aka internal id" do
    invoice = Invoice.new(amount: 2.0, due_at: '2019-05-20')

    assert_not invoice.valid?
  end

  test "invalid without amount" do
    invoice = Invoice.new(iid: 2, due_at: '2019-05-20')

    assert_not invoice.valid?
  end

  test "invalid without due_at" do
    invoice = Invoice.new(iid: 2, amount: 4.0)

    assert_not invoice.valid?
  end

  test "valid with iid amount and due at" do
    invoice = Invoice.new

    assert_equal false, invoice.valid?
  end
end
