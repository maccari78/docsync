class SecretariesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: %i[index destroy]
  before_action :set_secretary, only: %i[show edit update destroy]

  def index
    @secretaries = User.where(role: :secretary)
  end

  def show; end

  def new
    @secretary = User.new
    @clinics = Clinic.all
    @professionals = Professional.all
  end

  def edit
    @clinics = Clinic.all
    @professionals = Professional.all
  end

  def create
    filtered_params = secretary_params
    professional_ids = filtered_params.delete(:professional_ids)&.reject(&:blank?) || []

    @secretary = User.new(filtered_params.merge(role: :secretary))

    if @secretary.save
      @secretary.professional_ids = professional_ids if professional_ids.present?
      redirect_to secretary_path(@secretary), notice: 'Secretary was successfully created.'
    else
      @clinics = Clinic.all
      @professionals = Professional.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    filtered_params = secretary_params
    professional_ids = filtered_params.delete(:professional_ids)&.reject(&:blank?) || []

    if @secretary.update(filtered_params)
      @secretary.professional_ids = professional_ids if professional_ids.present?
      redirect_to secretary_path(@secretary), notice: 'Secretary was successfully updated.'
    else
      @clinics = Clinic.all
      @professionals = Professional.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @secretary.destroy
    redirect_to secretaries_url, notice: 'Secretary was successfully destroyed.'
  end

  private

  def set_secretary
    @secretary = User.find(params[:id])
  end

  def secretary_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :clinic_id,
                                 professional_ids: [])
  end

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless current_user&.role == 'admin'
  end
end
