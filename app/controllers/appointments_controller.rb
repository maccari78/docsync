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

    @appointments = @appointments.paginate(page: params[:page], per_page: 12)
  end

  def show; end

  def debug_patient_professional_relation
    return unless patient?

    patient = Patient.find_by(email: current_user.email)

    Rails.logger.debug { '=== DEBUG PATIENT-PROFESSIONAL RELATION ===' }
    Rails.logger.debug { "Patient: #{patient.inspect}" }
    Rails.logger.debug { "Patient ID: #{patient&.id}" }
    Rails.logger.debug { "Professional ID from patient: #{patient&.professional_id}" }

    if patient&.professional_id.present?
      professional = Professional.find_by(id: patient.professional_id)
      Rails.logger.debug { "Professional found: #{professional.present?}" }
      Rails.logger.debug { "Professional: #{professional&.inspect}" }
    else
      Rails.logger.debug { 'No professional_id found for patient' }
    end

    Rails.logger.debug { '=== END DEBUG ===' }
  end

  def new
    @appointment = Appointment.new(date: params[:date])
    if patient?
      patient = Patient.find_by(email: current_user.email)
      if patient
        @appointment.patient_id = patient.id

        professional = Professional.find_by(user_id: patient.professional_id)
        if professional
          @appointment.professional_id = professional.id
          @appointment.clinic_id = professional.clinic_id
          @appointment.status = 'pending'
          @available_times = available_times_for_professional(professional, @appointment.date)
        else
          @available_times = []
          flash.now[:alert] = 'No tienes un profesional asignado. Por favor contacta a la clínica.'
        end
      else
        redirect_to appointments_path, alert: 'No patient profile found.'
        nil
      end
    else
      @available_times = []
    end
  end

  def edit; end

  def create
    @appointment = Appointment.new(appointment_params)

    if patient?
      patient = Patient.find_by(email: current_user.email)
      if patient
        @appointment.patient_id = patient.id

        professional = Professional.find_by(user_id: patient.professional_id)
        if professional
          @appointment.professional_id = professional.id
          @appointment.clinic_id = professional.clinic_id
          @appointment.status = 'pending'
        else
          @available_times = []
          @appointment.errors.add(:base, 'No tienes un profesional asignado. Por favor contacta a la clínica.')
          render :new, status: :unprocessable_entity
          return
        end
      end
    elsif professional?
      @appointment.professional_id = current_professional.id
    end

    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment created successfully.'
    else
      if patient?
        patient = Patient.find_by(email: current_user.email)
        if patient
          professional = Professional.find_by(user_id: patient.professional_id)
          @available_times = available_times_for_professional(professional, @appointment.date) || []
        else
          @available_times = []
        end
      else
        @available_times = []
      end

      Rails.logger.debug { "Appointment errors: #{@appointment.errors.full_messages}" }
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
    Rails.logger.info "Initiating payment for appointment #{@appointment.id}"
    unless @appointment.confirmed?
      Rails.logger.warn "Unconfirmed appointment: #{@appointment.id}"
      redirect_to appointment_path(@appointment), alert: 'The appointment must be confirmed to initiate payment.'
      return
    end

    if @appointment.payment&.approved?
      Rails.logger.warn "Already paid appointment: #{@appointment.id}"
      redirect_to appointment_path(@appointment), alert: 'The appointment has already been paid.'
      return
    end

    amount = 1000
    Rails.logger.info "Creating payment with amount: #{amount}"

    payment = @appointment.payment || @appointment.create_payment!(
      amount: amount / 100.0,
      status: :pending
    )
    Rails.logger.info "Payment created: ID #{payment.id}"

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
      Rails.logger.info "Stripe session created: ID #{session.id}"

      payment.update(external_payment_id: session.id)
      Rails.logger.info "Payment updated with external_payment_id: #{session.id}"

      redirect_to session.url, allow_other_host: true
      Rails.logger.info "Redirecting to Stripe: #{session.url}"
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      redirect_to appointment_path(@appointment), alert: "Error processing payment: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}\n#{e.backtrace.join("\n")}"
      redirect_to appointment_path(@appointment), alert: 'Unexpected error initiating payment.'
    end
  end

  def pay
    unless @appointment.confirmed? || @appointment.completed?
      redirect_to appointment_path(@appointment), alert: 'The appointment is not available for payment.'
      return
    end
    return unless @appointment.payment&.approved?

    redirect_to appointment_path(@appointment), alert: 'The appointment is already paid.'
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
      redirect_to appointment_path(@appointment), notice: 'Payment successful!'
    else
      redirect_to appointment_path(@appointment),
                  alert: 'The payment is being processed. We will notify you when it is complete.'
    end
  end

  def failure
    @appointment.payment.update(status: :rejected) if @appointment.payment
    redirect_to appointment_path(@appointment), alert: 'The payment failed. Please try again.'
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
        redirect_to root_path, alert: 'You are not authorized to access this appointment.'
      end
    else
      @appointment = Appointment.deleted.find(params[:id])
      unless admin?
        redirect_to root_path,
                    alert: 'Only admins can restore or permanently delete appointments.'
      end
    end
  end

  def appointment_params
    permitted_params = params.require(:appointment).permit(:patient_id, :professional_id, :clinic_id, :date, :time,
                                                           :status, :treatment_details)
    if permitted_params[:time].present? && patient?
      permitted_params[:time] = begin
        Time.zone.parse(permitted_params[:time])
      rescue StandardError
        permitted_params[:time]
      end
    end
    permitted_params
  end

  def ensure_admin
    return if admin?

    redirect_to root_path,
                alert: 'Only admins can access deleted appointments or perform restore/permanent delete actions.'
  end

  def restrict_patient_actions
    return unless patient?

    redirect_to appointments_path, alert: 'Patients cannot perform this action.' if %w[edit update
                                                                                       destroy].include?(action_name)
  end

  def available_times_for_professional(professional, date)
    return [] unless professional && date

    start_time = Time.parse('09:00')
    end_time = Time.parse('17:00')
    interval = 30.minutes
    all_times = []

    current_time = start_time
    while current_time <= end_time
      all_times << current_time
      current_time += interval
    end

    booked_times = Appointment.where(professional_id: professional.id, date: date)
                              .where(deleted_at: nil)
                              .pluck(:time)
                              .map { |t| t.strftime('%H:%M') }

    all_times.reject { |time| booked_times.include?(time.strftime('%H:%M')) }
  end
end
