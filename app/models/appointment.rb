class Appointment < ApplicationRecord
  belongs_to :patient, class_name: 'User', inverse_of: :appointments_as_patient
  belongs_to :professional, inverse_of: :appointments
  belongs_to :clinic, inverse_of: :appointments

  validates :patient_id, :professional_id, :clinic_id, :date, :time, presence: true
  validate :date_not_in_past

  enum :status, { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' }, default: 'pending'

  private

  def date_not_in_past
    if date.present? && date < Date.today
      errors.add(:date, "it cannot be in the past")
    end
  end
end