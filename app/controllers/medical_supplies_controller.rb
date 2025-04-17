class MedicalSuppliesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_secretary!
  before_action :set_medical_supply, only: %i[show edit update destroy add_stock remove_stock]

  def index
    if admin?
      @medical_supplies = MedicalSupply.all
      @medical_supplies = @medical_supplies.where(clinic_id: params[:clinic_id]) if params[:clinic_id].present?
    elsif current_user.clinic
      @medical_supplies = current_user.clinic.medical_supplies
    else
      redirect_to root_path, alert: 'No clinic assigned to this user.'
      return
    end

    @medical_supplies = @medical_supplies.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?

    @medical_supplies = @medical_supplies.order(:name).page(params[:page]).per_page(12)
  end

  def show; end

  def new
    @medical_supply = MedicalSupply.new
  end

  def edit; end

  def create
    @medical_supply = MedicalSupply.new(medical_supply_params)
    @medical_supply.clinic = current_user.clinic if secretary?
    if @medical_supply.save
      redirect_to @medical_supply, notice: 'Medical supply was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medical_supply.update(medical_supply_params)
      redirect_to @medical_supply, notice: 'Medical supply was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medical_supply.destroy
    redirect_to medical_supplies_url, notice: 'Medical supply was successfully destroyed.'
  end

  def add_stock
    quantity = params[:quantity].to_i
    if quantity.positive? && @medical_supply.add_stock(quantity, current_user)
      redirect_to @medical_supply, notice: 'Stock updated successfully.'
    else
      redirect_to @medical_supply, alert: 'Invalid quantity or error updating stock.'
    end
  end

  def remove_stock
    quantity = params[:quantity].to_i
    if quantity.positive? && @medical_supply.remove_stock(quantity, current_user)
      redirect_to @medical_supply, notice: 'Stock updated successfully.'
    else
      redirect_to @medical_supply, alert: 'Insufficient stock or invalid quantity.'
    end
  end

  private

  def set_medical_supply
    @medical_supply = MedicalSupply.find(params[:id])
  end

  def medical_supply_params
    params.require(:medical_supply).permit(:name, :description, :stock_quantity, :minimum_stock, :clinic_id)
  end
end
