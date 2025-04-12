class ProfessionalsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: %i[new create destroy] 
  before_action :restrict_access, except: %i[index show] 
  before_action :set_professional, only: %i[show edit update destroy]

  def index
    @professionals = if admin?
                       Professional.all
                     elsif professional?
                       Professional.where(id: current_professional.id)
                     elsif secretary?
                       current_secretary.professionals
                     else
                       Professional.none
                     end
  end

  def show; end

  def new
    @professional = Professional.new
    @clinics = Clinic.all
  end

  def edit
    @clinics = Clinic.all
  end

  def create
    user = User.new(
      first_name: professional_params[:first_name],
      last_name: professional_params[:last_name],
      email: professional_params[:email],
      password: professional_params[:password],
      password_confirmation: professional_params[:password_confirmation],
      role: :professional
    )

    if user.save
      @professional = Professional.new(
        user: user,
        clinic_id: professional_params[:clinic_id],
        specialty: professional_params[:specialty] || 'dentist',
        license_number: professional_params[:license_number]
      )

      if @professional.save
        redirect_to @professional, notice: 'Professional was successfully created.'
      else
        @clinics = Clinic.all
        render :new, status: :unprocessable_entity
      end
    else
      @professional = Professional.new
      @clinics = Clinic.all
      user.errors.each do |error|
        @professional.errors.add(error.attribute, error.message)
      end
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @professional.update(professional_params.except(:first_name, :last_name, :email, :password, :password_confirmation))
      @professional.user.update(
        first_name: professional_params[:first_name],
        last_name: professional_params[:last_name],
        email: professional_params[:email]
      )
      redirect_to @professional, notice: 'Professional was successfully updated.'
    else
      @clinics = Clinic.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @professional.destroy
    redirect_to professionals_url, notice: 'Professional was successfully destroyed.'
  end

  private

  def set_professional
    @professional = Professional.find(params[:id])
    unless admin? || (professional? && @professional == current_professional) ||
           (secretary? && current_secretary.professionals.include?(@professional))
      redirect_to root_path, alert: 'You are not authorized to access this professional.'
    end
  end

  def professional_params
    params.require(:professional).permit(:first_name, :last_name, :email, :password, :password_confirmation,
                                         :clinic_id, :specialty, :license_number)
  end

  def restrict_access
    redirect_to root_path, alert: 'Access denied.' if patient? || (!admin? && %w[new create edit update destroy].include?(action_name))
  end

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless current_user&.role == 'admin'
  end
end