class AdminDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @total_appointments = Appointment.count
    @total_patients = Patient.count
    @total_clinics = Clinic.count
    @total_professionals = Professional.count
    @total_secretaries = User.where(role: :secretary).count
    @appointments_by_status = Appointment.group(:status).count
    @recent_appointments = Appointment.where(created_at: 7.days.ago..Time.now).count
    @new_patients = Patient.where(created_at: 1.month.ago..Time.now).count
    scope = Appointment.joins(:clinic)
    scope = scope.where(clinic_id: params[:clinic_id]) if params[:clinic_id].present?
    if params[:start_date].present? && params[:end_date].present?
      scope = scope.where(created_at: params[:start_date]..params[:end_date])
    end
    @appointments_by_clinic = scope.group('clinics.name').count
  end

  private

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless admin?
  end
end