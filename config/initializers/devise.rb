Devise.setup do |config|
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth, :omniauth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  config.omniauth :google_oauth2, 
                  ENV['GOOGLE_CLIENT_ID'], 
                  ENV['GOOGLE_CLIENT_SECRET'],
                  {
                    scope: 'email,profile',
                    prompt: 'select_account',
                    redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
                    provider_ignores_state: true
                  }

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  Warden::Manager.serialize_into_session do |user|
    Rails.logger.debug { "Serializing user into session: #{user.id}" }
    user.id.to_s 
  end

  Warden::Manager.serialize_from_session do |id|
    Rails.logger.debug { "Deserializing user from session with ID: #{id}" }
    User.find_by(id: id)
  end

  config.secret_key = ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base
end