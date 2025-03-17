class Appointment < ApplicationRecord
  belongs_to :patient, class_name: 'User', inverse_of: :appointments_as_patient
  belongs_to :professional, inverse_of: :appointments
  belongs_to :clinic, inverse_of: :appointments

  validates :date, :time, presence: true
  enum :status, { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' },
       default: 'pending'
end
