class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[show edit update destroy]

  def index
    @appointments = if admin?
                      Appointment.all
                    elsif professional?
                      current_professional.appointments
                    elsif secretary?
                      professional_ids = current_secretary.professionals.pluck(:id)
                      Appointment.where(professional_id: professional_ids)
                    elsif patient?
                      Appointment.where(patient_id: current_user.id)
                    else
                      Appointment.none
                    end

    Rails.logger.debug do
      "Appointments for JSON: #{@appointments.map do |a|
        { id: a.id, title: "#{a.patient&.email || 'N/A'} - #{a.time.strftime('%H:%M')}",
          start: a.date.to_date.strftime('%Y-%m-%d') + 'T' + a.time.strftime('%H:%M:%S') }
      end.to_json}"
    end

    respond_to do |format|
      format.html
      format.json do
        render json: @appointments.map { |a|
          {
            id: a.id,
            title: "#{a.patient&.email || 'N/A'} - #{a.time.strftime('%H:%M')}",
            start: a.date.to_date.strftime('%Y-%m-%d') + 'T' + a.time.strftime('%H:%M:%S')
          }
        }
      end
    end
  end

  def show; end

  def new
    @appointment = Appointment.new(date: params[:date])
  end

  def edit; end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.patient = current_user if patient?
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
    @appointment.destroy
    redirect_to appointments_path, notice: 'Appointment deleted successfully.'
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
    # Asegurarse de que el usuario tenga permiso para ver/editar este turno
    unless admin? || (professional? && @appointment.professional == current_professional) ||
           (secretary? && current_secretary.professionals.include?(@appointment.professional)) ||
           (patient? && @appointment.patient_id == current_user.id)
      redirect_to root_path, alert: 'You are not authorized to access this appointment.'
    end
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :professional_id, :clinic_id, :date, :time, :status)
  end
end
