class Users::AuthController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def google_oauth2
    Rails.logger.info 'Users::AuthController#google_oauth2 forwarding to OmniAuth'
    redirect_to user_google_oauth2_omniauth_authorize_path
  end
end
