class Professional < ApplicationRecord
  belongs_to :user
  has_many :appointments
  enum specialty: { dentist: 0 }
end