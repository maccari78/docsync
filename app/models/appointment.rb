class Appointment < ApplicationRecord
  belongs_to :patient, class_name: 'Patient', inverse_of: :appointments
  belongs_to :professional, inverse_of: :appointments
  belongs_to :clinic, inverse_of: :appointments
  has_one :conversation, dependent: :destroy

  validates :patient_id, :professional_id, :clinic_id, :date, :time, presence: true
  validate :date_not_in_past

  has_one :payment, dependent: :destroy

  enum :status, { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' },
       default: 'pending'

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def destroy
    if has_attribute?(:deleted_at)
      update(deleted_at: Time.current)
    else
      super
    end
  end

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    Rails.logger.info "Intentando restaurar turno #{id}"
    result = update(deleted_at: nil)
    Rails.logger.info "Resultado de la restauración: #{result}, errores: #{errors.full_messages.join(', ')}"
    result
  end

  def can_hard_destroy?
    payment.nil? || payment.rejected?
  end

  def hard_destroy!
    raise 'No se puede eliminar permanentemente un turno con pago aprobado' unless can_hard_destroy?

    transaction do
      payment.destroy if payment
      delete
    end
  end

  after_create :create_conversation, if: :status_confirmed_on_create?
  after_create :send_confirmation_email, if: :status_confirmed_on_create?
  after_update :create_conversation, if: :status_changed_to_confirmed?
  after_update :send_confirmation_email, if: :status_changed_to_confirmed?
  after_update :send_post_appointment_email, if: :status_changed_to_completed?

  private

  def status_changed_to_confirmed?
    saved_change_to_status? && status == 'confirmed'
  end

  def status_confirmed_on_create?
    Rails.logger.info "Estado al crear: #{status}"
    status == 'confirmed'
  end

  def status_changed_to_completed?
    saved_change_to_status? && status == 'completed'
  end

  def send_confirmation_email
    AppointmentMailer.confirmation_email(self).deliver_now # Cambiado a deliver_now
    Rails.logger.info "Correo de confirmación enviado a #{patient.email} para el turno #{id}"
  rescue StandardError => e
    Rails.logger.error "Fallo al enviar correo de confirmación para el turno #{id}: #{e.message}"
  end

  def send_post_appointment_email
    AppointmentMailer.post_appointment_email(self).deliver_now
    Rails.logger.info "Correo post-turno enviado a #{patient.email} para el turno #{id}"
  rescue StandardError => e
    Rails.logger.error "Fallo al enviar correo post-turno para el turno #{id}: #{e.message}"
  end

  def date_not_in_past
    return unless date.present? && date < Date.today

    errors.add(:date, 'no puede ser en el pasado')
  end

  def create_conversation
    return if conversation.present?

    secretary = ProfessionalsSecretary.find_by(professional: professional)&.secretary
    return unless secretary

    patient_user = User.find_by(email: patient.email)
    return unless patient_user

    Conversation.create!(
      appointment: self,
      sender: secretary,
      receiver: patient_user
    )
  end
end
