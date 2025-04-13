class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :restore_user_from_cookie, unless: :logout_action?
  before_action :log_session_data
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Desactiva CSRF para OmniAuth y Stripe webhook
  skip_before_action :verify_authenticity_token, if: :bypass_csrf_verification?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end

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

  helper_method :admin?, :professional?, :secretary?, :patient?, :current_professional, :current_secretary,
                :current_patient

  private

  def bypass_csrf_verification?
    omniauth_request? || request.path.start_with?('/stripe/webhook')
  end

  def restore_user_from_cookie
    if warden.authenticated? || session[:user_id].present?
      Rails.logger.info 'User already authenticated or session present, skipping restore'
      return
    end

    unless cookies.signed[:user_id]
      Rails.logger.info 'No user_id cookie found, skipping restore'
      return
    end

    user_id = cookies.signed[:user_id]
    user = User.find_by(id: user_id)
    unless user
      Rails.logger.info "User not found for cookie user_id: #{user_id}, clearing cookie"
      cookies.delete(:user_id, secure: Rails.env.production?, same_site: :lax, httponly: true, domain: :all)
      return
    end

    warden.set_user(user)
    session[:user_id] = user.id
    Rails.logger.info "Restored user from cookie: #{user.inspect}"
  end

  def logout_action?
    controller_name == 'sessions' && action_name == 'destroy'
  end

  def after_sign_in_path_for(resource)
    set_user_session(resource)
    appointments_path
  end

  def set_user_session(resource)
    Rails.logger.info "After sign in for user: #{resource.inspect}"
    warden.set_user(resource)
    session[:user_id] = resource.id
    cookies.signed[:user_id] = { value: resource.id, secure: Rails.env.production?, httponly: true, same_site: :lax }
    log_session_details(resource)
  end

  def log_session_details(_resource)
    Rails.logger.info "Warden user set: #{warden.user.inspect}"
    Rails.logger.info "Session[:user_id] set to: #{session[:user_id]}"
    Rails.logger.info "Cookies after sign in: #{cookies.to_hash}"
  end

  def log_session_data
    Rails.logger.info "Session data: #{session.to_hash}"
    Rails.logger.info "Warden user key: #{session['warden.user.user.key']}"
    Rails.logger.info "Current user: #{current_user&.inspect}"
    Rails.logger.info "Cookies: #{cookies.to_hash}"
  end

  def omniauth_request?
    Rails.logger.info "Checking if omniauth_request? - Path: #{request.path}, OmniAuth env: #{request.env['omniauth.auth'].present?}, Action: #{action_name}"
    request.path.start_with?('/users/auth/') || request.env['omniauth.auth'].present? || action_name == 'failure'
  end

  def fix_session_user_id
    user_id = session['warden.user.user.key']&.first&.first
    return unless user_id

    uuid_format = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
    return if user_id.match?(uuid_format)

    Rails.logger.info "Invalid user ID in session: #{user_id.inspect}. Resetting session."
    reset_session
    flash[:alert] = 'Your session was invalid. Please sign in again.'
    redirect_to new_user_session_path
  end
end
