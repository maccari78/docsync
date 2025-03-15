class Clinic < ApplicationRecord
  has_many :users
  has_many :professionals, through: :users
  has_many :appointments
end