# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user!
      
      private
      
      def authenticate_api_user!
        token = request.headers['Authorization']&.split(' ')&.last
        return render_unauthorized unless token
        
        begin
          decoded = JWT.decode(token, JWT_SECRET, true, { algorithm: JWT_ALGORITHM })
          @current_api_user = User.find(decoded[0]['user_id'])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          render_unauthorized
        end
      end
      
      def render_unauthorized
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
      
      def current_api_user
        @current_api_user
      end
    end
  end
end