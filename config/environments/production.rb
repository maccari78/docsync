require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true
  config.assets.compile = false
  config.force_ssl = false

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  config.action_controller.default_protect_from_forgery = true
  config.action_controller.protect_from_forgery with: :exception, unless: -> { request.format.turbo_stream? }
  config.action_controller.allow_forgery_protection = true
  config.action_controller.protect_from_forgery with: :exception, except: :omniauth_callbacks

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "docsync-8ti1.onrender.com" }
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "gmail.com",
    user_name: ENV['GMAIL_USERNAME'],
    password: ENV['GMAIL_PASSWORD'],
    authentication: "plain",
    enable_starttls_auto: true
  }
  
  config.active_storage.service = :cloudinary

  config.action_cable.mount_path = "/cable"
  if ENV["RENDER"]
    config.action_cable.url = "wss://docsync-8ti1.onrender.com/cable"
    config.action_cable.allowed_request_origins = ["https://docsync-8ti1.onrender.com"]
  else
    config.action_cable.url = "ws://0.0.0.0:4000/cable"
    config.action_cable.allowed_request_origins = ["http://0.0.0.0:4000"]
  end

  config.assets.js_compressor = nil
  config.public_file_server.enabled = true
  config.force_ssl = false
end