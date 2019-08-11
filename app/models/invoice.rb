class Invoice < ApplicationRecord
  validates :iid, :amount, numericality: true
  validates :due_at, presence: true
end