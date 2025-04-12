Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies(scope: :user).unshift :database_authenticatable
  manager.failure_app = Devise::FailureApp
end