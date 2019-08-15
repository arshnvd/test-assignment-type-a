class Invoice < ApplicationRecord

  COEFFICIENT_FOR_LATE  = 0.3
  COEFFICIENT_FOR_EARLY = 0.5

  before_save :calculate_selling_price

  validates_numericality_of :amount
  validates_numericality_of :internal_id, message: 'ID is not a number'
  validates :due_at, presence: true

  private

    def calculate_selling_price
      self.selling_price = (coefficient * amount)
    end

    def coefficient
      creation_time = created_at.presence || DateTime.now
      creation_time = creation_time.advance(days: 30)
      result        = creation_time.compare_with_coercion(due_at)

      result.negative? ? COEFFICIENT_FOR_EARLY : COEFFICIENT_FOR_LATE
    end
end