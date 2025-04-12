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
                  professional_user_ids = current_secretary.professionals.pluck(:user_id)
                  Patient.where(professional_id: professional_user_ids)
                elsif patient?
                  Patient.where(email: current_user.email)
                else
                  Patient.none
                end

    if params[:name].present?
      name = params[:name].strip.downcase
      @patients = @patients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?', "%#{name}%", "%#{name}%")
    end

    if params[:professional_id].present? && (admin? || secretary?)
      @patients = @patients.where(professional_id: params[:professional_id])
    end

    @patients = @patients.paginate(page: params[:page], per_page: 12)
  end

  def show; end

  def new
    @patient = Patient.new
  end

  def edit; end

  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to @patient, notice: 'Patient was successfully created.'
    else
      Rails.logger.error "Failed to create patient: #{@patient.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Rails.logger.info "Attempting to update patient with params: #{patient_params.inspect}"
    begin
      if @patient.update(patient_params)
        Rails.logger.info "Patient updated successfully: #{@patient.inspect}"
        redirect_to @patient, notice: 'Patient was successfully updated.'
      else
        Rails.logger.error "Failed to update patient: #{@patient.errors.full_messages.join(', ')}"
        render :edit, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "Error updating patient: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
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
    unless admin? ||
           (professional? && @patient.professional_id == current_professional.user_id) ||
           (secretary? && current_secretary.professionals.pluck(:user_id).include?(@patient.professional_id)) ||
           (patient? && @patient.email == current_user.email)
      redirect_to root_path, alert: 'You are not authorized to access this patient.'
    end
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :phone, :professional_id, :photo)
  end

  def restrict_access
    return if patient? && %w[show edit
                             update].include?(action_name) && Patient.find(params[:id])&.email == current_user.email

    redirect_to root_path, alert: 'Access denied.' if patient? || (!admin? && %w[destroy].include?(action_name))
  end
end
