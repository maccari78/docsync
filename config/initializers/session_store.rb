Rails.application.config.session_store :cookie_store,
  key: '_docsync_session',
  # domain: :all,
  secure: Rails.env.production?,
  same_site: :lax,
  httponly: true
Rails.logger.info "Session store configured: key=#{Rails.application.config.session_options[:key]}, secure=#{Rails.application.config.session_options[:secure]}"