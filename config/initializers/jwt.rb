# config/initializers/jwt.rb
JWT_SECRET = Rails.application.credentials.secret_key_base || 'your-secret-key-for-development'
JWT_ALGORITHM = 'HS256'