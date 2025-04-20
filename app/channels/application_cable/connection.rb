module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless current_user
    end

    private

    def find_verified_user
      # Intenta obtener el usuario desde Warden
      if (user = env["warden"].user)
        return user
      end

      # Si Warden falla, intenta obtener el usuario desde la cookie user_id
      if (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        return user if user
      end

      reject_unauthorized_connection
    end
  end
end