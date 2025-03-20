class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def current_professional
    @current_professional ||= current_user.professional if current_user&.role == 'professional'
  end

  def current_secretary
    @current_secretary ||= current_user if current_user&.role == 'secretary'
  end

  def current_patient
    @current_patient ||= current_user if current_user&.role == 'patient'
  end

  def admin?
    current_user&.role == 'admin'
  end

  def professional?
    current_user&.role == 'professional'
  end

  def secretary?
    current_user&.role == 'secretary'
  end

  def patient?
    current_user&.role == 'patient'
  end

  private

  def after_sign_in_path_for(resource)
    case resource.role
    when 'admin'
      admin_dashboards_path
    else
      appointments_path
    end
  end
end