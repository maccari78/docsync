class Professional < ApplicationRecord
  belongs_to :user, inverse_of: :professional, dependent: :destroy
  belongs_to :clinic, inverse_of: :professionals
  has_many :appointments, dependent: :destroy, inverse_of: :professional
  has_many :patients, dependent: :destroy
  has_many :professionals_secretaries, dependent: :destroy
  has_many :secretaries, through: :professionals_secretaries, source: :secretary
  enum :specialty, { dentist: 0 }, default: :dentist

  validates :specialty, presence: true
  validates :clinic_id, presence: true

  delegate :email, to: :user, prefix: true
end