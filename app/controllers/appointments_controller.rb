class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[show edit update destroy]

  def index
    @appointments = if current_user
                      case current_user.role
                      when 'professional'
                        current_user.appointments_as_professional
                      when 'patient'
                        current_user.appointments_as_patient
                      else
                        Appointment.all # Para admin/secretary
                      end
                    else
                      []
                    end
  end

  def show; end

  def new
    @appointment = Appointment.new
  end

  def edit; end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.patient = current_user if current_user.role == 'patient'
    @appointment.professional = current_user.professional if current_user.role == 'professional'

    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: 'Appointment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to appointments_path, notice: 'Appointment was successfully deleted.'
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :professional_id, :clinic_id, :date, :time, :status)
  end
end
