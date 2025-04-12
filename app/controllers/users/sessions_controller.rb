class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]

  def new
    Rails.logger.info 'SessionsController#new started'
    super
    Rails.logger.info 'SessionsController#new completed'
  end

  def create
    Rails.logger.info "SessionsController#create started with params: #{params.inspect}"
    Rails.logger.info "CSRF token: #{form_authenticity_token}"
    super
    Rails.logger.info 'SessionsController#create completed'
  end

  def destroy
    cookies.delete(:user_id)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Signed out successfully.' }
    end
  end
end
