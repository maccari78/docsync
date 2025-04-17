class AdminDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    scope = Appointment.joins(:clinic)
    supply_scope = MedicalSupply.joins(:clinic)

    if params[:clinic_id].present?
      scope = scope.where(clinic_id: params[:clinic_id])
      supply_scope = supply_scope.where(clinic_id: params[:clinic_id])
    end

    if params[:start_date].present? && params[:end_date].present?
      scope = scope.where(created_at: params[:start_date]..params[:end_date])
      supply_scope = supply_scope.where(created_at: params[:start_date]..params[:end_date])
    end

    @total_appointments = scope.count
    @total_patients = Patient.count
    @total_clinics = Clinic.count
    @total_professionals = Professional.count
    @total_secretaries = User.where(role: :secretary).count
    @appointments_by_status = scope.group(:status).count
    @recent_appointments = scope.where(created_at: 7.days.ago..Time.now).count
    @new_patients = Patient.where(created_at: 1.month.ago..Time.now).count
    @appointments_by_clinic = scope.group('clinics.name').count

    @total_medical_supplies = supply_scope.count
    @low_stock_supplies = supply_scope.where('stock_quantity < minimum_stock').count
    @medical_supplies_by_clinic = supply_scope.group('clinics.name').count
  end

  private

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless admin?
  end
end