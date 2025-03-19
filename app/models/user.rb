class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :clinic, optional: true, inverse_of: :users
  has_one :professional, dependent: :destroy, inverse_of: :user
  has_many :appointments_as_patient, class_name: 'Appointment', foreign_key: 'patient_id', inverse_of: :patient
  has_many :appointments_as_professional, through: :professional, source: :appointments
  has_many :patients_as_professional, through: :professional, source: :patients
  has_many :professionals_secretaries, foreign_key: :secretary_id, dependent: :destroy
  has_many :professionals, through: :professionals_secretaries

  enum :role, { patient: 0, secretary: 1, professional: 2, admin: 3 }, default: :patient

  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  def professional
    super if role == 'professional'
  end

  def name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      email.split('@').first
    end
  end
end
