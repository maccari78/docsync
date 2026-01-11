module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless current_user
    end

    private

    def find_verified_user
      # 1. Web app: Intenta obtener el usuario desde Warden
      if (user = env["warden"]&.user)
        Rails.logger.info "ActionCable: User authenticated via Warden: #{user.email}"
        return user
      end

      # 2. Mobile app: Intenta obtener el usuario desde JWT en query params
      if (token = request.params['token'])
        begin
          decoded = JWT.decode(token, JWT_SECRET, true, { algorithm: JWT_ALGORITHM })
          user = User.find_by(id: decoded[0]['user_id'])
          if user
            Rails.logger.info "ActionCable: User authenticated via JWT: #{user.email}"
            return user
          end
        rescue JWT::DecodeError => e
          Rails.logger.error "ActionCable: JWT decode error: #{e.message}"
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error "ActionCable: User not found: #{e.message}"
        end
      end

      # 3. Fallback: Si Warden y JWT fallan, intenta obtener el usuario desde la cookie user_id
      if (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user
          Rails.logger.info "ActionCable: User authenticated via signed cookie: #{user.email}"
          return user
        end
      end

      Rails.logger.error "ActionCable: Connection rejected - no valid authentication method"
      reject_unauthorized_connection
    end
  end
end