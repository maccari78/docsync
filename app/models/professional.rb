class Professional < ApplicationRecord
  belongs_to :user, inverse_of: :professional
  has_many :appointments, dependent: :destroy, inverse_of: :professional
  has_many :patients, dependent: :destroy
  enum :specialty, { dentist: 0 }, default: :dentist

  delegate :email, to: :user, prefix: true
end
