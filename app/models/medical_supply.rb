class MedicalSupply < ApplicationRecord
  belongs_to :clinic, inverse_of: :medical_supplies

  validates :name, presence: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :clinic_id, presence: true

  def low_stock?
    stock_quantity < minimum_stock
  end

  def add_stock(quantity, user = nil)
    self.stock_quantity += quantity
    save
  end

  def remove_stock(quantity, user = nil)
    if stock_quantity >= quantity
      self.stock_quantity -= quantity
      save
    else
      errors.add(:stock_quantity, "insufficient stock")
      false
    end
  end
end