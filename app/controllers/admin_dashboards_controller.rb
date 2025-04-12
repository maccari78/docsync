class AdminDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @total_appointments = Appointment.count
    @total_patients = Patient.count
    @total_clinics = Clinic.count
    @total_professionals = Professional.count
    @total_secretaries = User.where(role: :secretary).count

    # Estadísticas por clínica
    @appointments_by_clinic = Appointment.joins(:clinic).group('clinics.name').count
  end

  private

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless admin?
  end
end