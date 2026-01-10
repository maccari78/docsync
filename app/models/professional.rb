class Professional < ApplicationRecord
  belongs_to :user, inverse_of: :professional, dependent: :destroy
  belongs_to :clinic, inverse_of: :professionals
  has_many :appointments, dependent: :destroy, inverse_of: :professional
  has_many :professionals_secretaries, dependent: :destroy
  has_many :secretaries, through: :professionals_secretaries, source: :secretary

  enum :specialty,
       { dentist: 0, general_practice: 1, cardiology: 2, pediatrics: 3, neurology: 4, dermatology: 5, other: 6 }, default: :dentist

  validates :specialty, presence: true
  validates :clinic_id, presence: true

  delegate :email, to: :user, prefix: true

  before_validation :set_default_specialty, on: %i[create update]

  def user_name
    user.name
  end

  private

  def set_default_specialty
    self.specialty = :dentist if specialty.nil?
  end
end
