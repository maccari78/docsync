class Clinic < ApplicationRecord
  has_many :users, dependent: :nullify, inverse_of: :clinic
  has_many :professionals, dependent: :destroy, inverse_of: :clinic
  has_many :secretaries, -> { where(role: :secretary) }, class_name: "User", inverse_of: :clinic
  has_many :appointments, dependent: :destroy, inverse_of: :clinic

  def professional_users
    users.where(role: :professional)
  end
end