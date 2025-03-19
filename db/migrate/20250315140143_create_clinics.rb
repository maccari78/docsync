class Clinic < ApplicationRecord
  has_many :users, dependent: :nullify, inverse_of: :clinic
  has_many :professionals, through: :users, source: :professional
  has_many :appointments, dependent: :destroy, inverse_of: :clinic

  # Método opcional para filtrar usuarios que son profesionales
  def professional_users
    users.where(role: :professional)
  end
end