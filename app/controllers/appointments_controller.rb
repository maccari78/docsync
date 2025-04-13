class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:payment_notification]
  before_action :set_appointment, only: %i[show edit update destroy initiate_payment success failure pay]
  before_action :ensure_admin, only: %i[deleted restore hard_destroy]
  before_action :restrict_patient_actions, only: %i[new create edit update destroy]
  skip_before_action :verify_authenticity_token, only: [:payment_notification]

  def index
    Rails.logger.debug { "Current user: #{current_user.inspect}" }
    Rails.logger.debug { "User role: #{current_user.role}" }

    @appointments = if admin?
                      Appointment.where(deleted_at: nil).includes(:patient, :professional).all
                    elsif professional?
                      current_professional.appointments.where(deleted_at: nil).includes(:patient)
                    elsif secretary?
                      Rails.logger.debug { "Current secretary: #{current_secretary.inspect}" }
                      professional_ids = current_secretary.professionals.pluck(:id)
                      Rails.logger.debug { "Professional IDs for secretary: #{professional_ids}" }
                      Appointment.where(deleted_at: nil).where(professional_id: professional_ids).includes(:patient)
                    elsif patient?
                      patient = Patient.find_by(email: current_user.email)
                      if patient
                        Appointment.where(deleted_at: nil).where(patient_id: patient.id).includes(:professional)
                      else
                        Appointment.none
                      end
                    else
                      Appointment.none
                    end

    @user_role = current_user.role

    Rails.logger.debug do
      "Appointments for JSON: #{@appointments.map do |a|
        { id: a.id, title: "#{a.patient&.name || 'N/A'} - #{a.time.strftime('%H:%M')}",
          start: a.date.to_date.strftime('%Y-%m-%d') + 'T' + a.time.strftime('%H:%M:%S') }
      end.to_json}"
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @appointments.map { |a|
          {
            id: a.id,
            title: "#{a.patient&.name || 'N/A'} - #{a.time.strftime('%H:%M')}",
            start: a.date.to_date.strftime('%Y-%m-%d') + 'T' + a.time.strftime('%H:%M:%S'),
            end: a.date.to_date.strftime('%Y-%m-%d') + 'T' + a.time.strftime('%H:%M:%S')
          }
        }
      end
    end
  end

  def list
    @appointments = if admin?
                      Appointment.active.includes(:patient, :professional, :clinic)
                    elsif professional?
                      current_professional.appointments.active.includes(:patient, :professional, :clinic)
                    elsif secretary?
                      professional_ids = current_secretary.professionals.pluck(:id)
                      Appointment.active.where(professional_id: professional_ids).includes(:patient, :professional,
                                                                                           :clinic)
                    elsif patient?
                      Appointment.active.where(patient_id: current_user.id).includes(:patient, :professional, :clinic)
                    else
                      Appointment.none
                    end

    @appointments = @appointments.where(date: params[:date]) if params[:date].present?

    if params[:professional_id].present? && (admin? || secretary?)
      @appointments = @appointments.where(professional_id: params[:professional_id])
    end

    @appointments = @appointments.where(clinic_id: params[:clinic_id]) if params[:clinic_id].present? && admin?

    @appointments = @appointments.where(status: params[:status]) if params[:status].present?

    if params[:patient_name].present?
      name = params[:patient_name].strip.downcase
      @appointments = @appointments.joins(:patient).where(
        'LOWER(patients.first_name) LIKE ? OR LOWER(patients.last_name) LIKE ?', "%#{name}%", "%#{name}%"
      )
    end

    @appointments = @appointments.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def new
    @appointment = Appointment.new(date: params[:date])
  end

  def edit; end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.status ||= 'pending'
    @appointment.professional = current_professional if professional?
    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      respond_to do |format|
        format.json { render json: { status: 'success' }, status: :ok }
        format.html { redirect_to appointments_path, notice: 'Appointment updated successfully.' }
      end
    else
      respond_to do |format|
        format.json do
          render json: { status: 'error', errors: @appointment.errors.full_messages }, status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless admin? || professional? ||
           (secretary? && current_secretary.professionals.include?(@appointment.professional)) ||
           (patient? && @appointment.patient_id == current_user.id)
      redirect_to root_path, alert: 'You are not authorized to delete this appointment.'
      return
    end

    if @appointment.soft_delete
      redirect_to appointments_path, notice: 'Appointment deleted successfully.'
    else
      redirect_to appointments_path, alert: 'Failed to delete appointment.'
    end
  end

  def deleted
    @deleted_appointments = Appointment.deleted.includes(:patient, :professional, :clinic)
                                       .paginate(page: params[:page], per_page: 13)
  end

  def restore
    @appointment = Appointment.deleted.find(params[:id])
    if @appointment.restore
      redirect_to deleted_appointments_path, notice: 'Appointment restored successfully.'
    else
      redirect_to deleted_appointments_path, alert: 'Failed to restore appointment.'
    end
  end

  def hard_destroy
    @appointment = Appointment.deleted.find(params[:id])

    if @appointment.can_hard_destroy?
      @appointment.hard_destroy!
      redirect_to deleted_appointments_path, notice: 'Appointment permanently deleted.'
    else
      redirect_to deleted_appointments_path,
                  alert: 'Cannot delete: appointment has approved/pending payment.'
    end
  rescue StandardError => e
    redirect_to deleted_appointments_path,
                alert: "Deletion failed: #{e.message}"
  end

  def initiate_payment
    Rails.logger.info "Iniciando pago para appointment #{@appointment.id}"
    unless @appointment.confirmed?
      Rails.logger.warn "Turno no confirmado: #{@appointment.id}"
      redirect_to appointment_path(@appointment), alert: 'El turno debe estar confirmado para iniciar el pago.'
      return
    end

    if @appointment.payment&.approved?
      Rails.logger.warn "Turno ya pagado: #{@appointment.id}"
      redirect_to appointment_path(@appointment), alert: 'El turno ya está pagado.'
      return
    end

    amount = 1000 # Ajusta según configuración
    Rails.logger.info "Creando pago con monto: #{amount}"

    payment = @appointment.payment || @appointment.create_payment!(
      amount: amount / 100.0,
      status: :pending
    )
    Rails.logger.info "Pago creado: ID #{payment.id}"

    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY', nil)
    Rails.logger.info 'Stripe API key configurada'

    begin
      session = Stripe::Checkout::Session.create({
                                                   payment_method_types: ['card'],
                                                   line_items: [{
                                                     price_data: {
                                                       currency: 'usd',
                                                       product_data: {
                                                         name: "Turno con #{@appointment.professional.user.name} - #{@appointment.date.strftime('%d/%m/%Y')}"
                                                       },
                                                       unit_amount: amount
                                                     },
                                                     quantity: 1
                                                   }],
                                                   mode: 'payment',
                                                   success_url: success_appointment_url(@appointment,
                                                                                        protocol: 'https'),
                                                   cancel_url: failure_appointment_url(@appointment, protocol: 'https'),
                                                   metadata: { payment_id: payment.id.to_s }
                                                 })
      Rails.logger.info "Sesión de Stripe creada: ID #{session.id}"

      payment.update(external_payment_id: session.id)
      Rails.logger.info "Pago actualizado con external_payment_id: #{session.id}"

      redirect_to session.url, allow_other_host: true
      Rails.logger.info "Redirigiendo a Stripe: #{session.url}"
    rescue Stripe::StripeError => e
      Rails.logger.error "Error de Stripe: #{e.message}"
      redirect_to appointment_path(@appointment), alert: "Error al procesar el pago: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Error inesperado: #{e.message}\n#{e.backtrace.join("\n")}"
      redirect_to appointment_path(@appointment), alert: 'Error inesperado al iniciar el pago.'
    end
  end

  def pay
    unless @appointment.confirmed? || @appointment.completed?
      redirect_to appointment_path(@appointment), alert: 'El turno no está disponible para pago.'
      return
    end
    return unless @appointment.payment&.approved?

    redirect_to appointment_path(@appointment), alert: 'El turno ya está pagado.'
    nil
  end

  def payment_notification
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV.fetch('STRIPE_WEBHOOK_SECRET', nil)

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      Rails.logger.error "Webhook JSON parse error: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Webhook signature verification failed: #{e.message}"
      return head :bad_request
    end

    case event.type
    when 'checkout.session.completed', 'checkout.session.async_payment_succeeded'
      session = event.data.object
      payment = Payment.find_by(id: session.metadata.payment_id)
      if payment
        if session.payment_status == 'paid'
          payment.update(status: :approved)
          AppointmentMailer.payment_confirmation(payment.appointment).deliver_later
          Rails.logger.info "Payment approved for appointment #{payment.appointment.id}, payment ID: #{payment.id}"
        else
          payment.update(status: :rejected)
          Rails.logger.info "Payment rejected for session: #{session.id}"
        end
      else
        Rails.logger.error "Payment not found for session: #{session.id}"
      end
    end

    head :ok
  end

  def success
    if @appointment.payment&.approved?
      redirect_to appointment_path(@appointment), notice: '¡Pago realizado con éxito!'
    else
      redirect_to appointment_path(@appointment), alert: 'El pago está procesando. Te notificaremos cuando se complete.'
    end
  end

  def failure
    @appointment.payment.update(status: :rejected) if @appointment.payment
    redirect_to appointment_path(@appointment), alert: 'El pago falló. Intenta nuevamente.'
  end

  private

  def set_appointment
    if action_name != 'restore' && action_name != 'hard_destroy'
      @appointment = if action_name == 'deleted'
                       Appointment.deleted.find(params[:id])
                     else
                       Appointment.active.find(params[:id])
                     end

      patient = patient? ? Patient.find_by(email: current_user.email) : nil

      unless admin? ||
             (professional? && @appointment.professional == current_professional) ||
             (secretary? && current_secretary.professionals.include?(@appointment.professional)) ||
             (patient? && patient && @appointment.patient_id == patient.id)
        redirect_to root_path, alert: 'No tienes autorización para acceder a este turno.'
      end
    else
      @appointment = Appointment.deleted.find(params[:id])
      unless admin?
        redirect_to root_path,
                    alert: 'Solo los administradores pueden restaurar o eliminar permanentemente turnos.'
      end
    end
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :professional_id, :clinic_id, :date, :time, :status,
                                        :treatment_details)
  end

  def ensure_admin
    return if admin?

    redirect_to root_path,
                alert: 'Solo los administradores pueden acceder a turnos eliminados o realizar acciones de restauración/eliminación permanente.'
  end

  def restrict_patient_actions
    return unless patient?

    redirect_to appointments_path, alert: 'Los pacientes no pueden realizar esta acción.'
  end
end
