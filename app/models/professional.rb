class Professional < ApplicationRecord
  belongs_to :user, inverse_of: :professional
  has_many :appointments, dependent: :destroy, inverse_of: :professional
  has_many :patients, foreign_key: :professional_id, dependent: :destroy # Nueva relación
  enum specialty: { dentist: 0 }, _default: :dentist
end