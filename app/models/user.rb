class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  belongs_to :clinic, optional: true
  has_one :professional
  has_many :appointments_as_patient, class_name: "Appointment", foreign_key: "patient_id"
  enum role: { patient: 0, secretary: 1, professional: 2, admin: 3 }
end