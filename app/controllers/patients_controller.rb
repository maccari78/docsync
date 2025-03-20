class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access, except: :index
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    @patients = if admin?
                  Patient.all
                elsif professional?
                  Patient.where(professional_id: current_professional.user_id)
                elsif secretary?
                  professional_ids = current_secretary.professionals.pluck(:id)
                  Patient.where(professional_id: professional_ids)
                else
                  Patient.none
                end
  end

  def show; end

  def new
    @patient = Patient.new
  end

  def edit; end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to @patient, notice: 'Patient was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: 'Patient was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_url, notice: 'Patient was successfully destroyed.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
    # Asegurarse de que el usuario tenga permiso para ver/editar este paciente
    unless admin? || (professional? && @patient.professional_id == current_professional.user_id) ||
           (secretary? && current_secretary.professionals.pluck(:id).include?(@patient.professional_id))
      redirect_to root_path, alert: 'You are not authorized to access this patient.'
    end
  end

  def patient_params
    params.require(:patient).permit(:name, :email, :phone, :professional_id, :photo)
  end

  def restrict_access
    redirect_to root_path, alert: 'Access denied.' if patient? || (!admin? && %w[destroy].include?(action_name))
  end
end
