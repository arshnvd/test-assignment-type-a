require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test "invalid without internal_id aka internal id" do
    invoice = Invoice.new(amount: 2.0, due_at: '2019-05-20')

    assert_not invoice.valid?
  end

  test "invalid without amount" do
    invoice = Invoice.new(internal_id: 2, due_at: '2019-05-20')

    assert_not invoice.valid?
  end

  test "invalid without due_at" do
    invoice = Invoice.new(internal_id: 2, amount: 4.0)

    assert_not invoice.valid?
  end

  test "valid with internal_id amount and due at" do
    invoice = Invoice.new

    assert_equal false, invoice.valid?
  end

  test "when uploaded more than 30 days before" do
    invoice = Invoice.new(due_at: 40.days.from_now, amount: 100, internal_id: rand(1000))

    invoice.save
    invoice.reload

    assert_equal 50.0, invoice.selling_price
  end

  test "when uploaded less than 30 days before" do
    invoice = Invoice.new(due_at: 10.days.from_now, amount: 100, internal_id: rand(1000))

    invoice.save
    invoice.reload

    assert_equal 30.0, invoice.selling_price
  end

  test "when uploaded 30 days before" do
    freeze_time do
      invoice = Invoice.new(due_at: 30.days.from_now, amount: 100, internal_id: rand(1000))
      invoice.save
      invoice.reload

      assert_equal 30.0, invoice.selling_price
    end
  end
end
