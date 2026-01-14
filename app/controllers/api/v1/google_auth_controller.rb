module Api
  module V1
    class GoogleAuthController < BaseController
      skip_before_action :authenticate_api_user!, only: [:create]

      # POST /api/v1/auth/google
      # Params: { id_token: "google_id_token_from_mobile" }
      def create
        id_token = params[:id_token]

        if id_token.blank?
          return render json: { error: 'ID token is required' }, status: :unprocessable_entity
        end

        begin
          # DEBUG: Decode token to see its audience
          token_parts = id_token.split('.')
          if token_parts.length >= 2
            decoded_payload = JSON.parse(Base64.decode64(token_parts[1]))
            Rails.logger.info "=== GOOGLE TOKEN DEBUG ==="
            Rails.logger.info "Token audience (aud): #{decoded_payload['aud']}"
            Rails.logger.info "Token azp (authorized party): #{decoded_payload['azp']}"
            Rails.logger.info "Expected client_id: #{ENV['GOOGLE_CLIENT_ID']}"
            Rails.logger.info "Token issuer (iss): #{decoded_payload['iss']}"
            Rails.logger.info "Token email: #{decoded_payload['email']}"
            Rails.logger.info "=========================="
          end

          # Verify Google ID token
          # Pass nil as third param to skip azp check (Android apps have different azp than aud)
          validator = GoogleIDToken::Validator.new
          payload = validator.check(id_token, ENV['GOOGLE_CLIENT_ID'], nil)

          if payload.nil?
            return render json: { error: 'Invalid Google ID token' }, status: :unauthorized
          end

          # Extract user info from verified token
          google_info = {
            email: payload['email'],
            given_name: payload['given_name'] || payload['name']&.split(' ')&.first,
            family_name: payload['family_name'] || payload['name']&.split(' ')&.last,
            sub: payload['sub'] # Google user ID
          }

          # Find or create user
          user = User.from_omniauth_mobile(google_info)

          if user.persisted?
            # Generate JWT token (same as email/password login)
            token = user.generate_jwt

            render json: {
              token: token,
              user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role
              }
            }, status: :ok
          else
            Rails.logger.error "Failed to create/find user: #{user.errors.full_messages}"
            render json: { error: 'Failed to authenticate with Google' }, status: :unprocessable_entity
          end

        rescue => e
          Rails.logger.error "Google OAuth error: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          render json: { error: 'Failed to verify Google token' }, status: :unauthorized
        end
      end
    end
  end
end
