# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_api_user!, only: [:create]
      
      # POST /api/v1/auth/login
      def create
        user = User.find_by(email: params[:email])
        
        if user&.valid_password?(params[:password])
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
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
      
      # DELETE /api/v1/auth/logout
      def destroy
        # JWT is stateless, client just needs to delete the token
        render json: { message: 'Logged out successfully' }, status: :ok
      end
      
      # GET /api/v1/auth/me
      def me
        render json: {
          user: {
            id: current_api_user.id,
            email: current_api_user.email,
            name: current_api_user.name,
            role: current_api_user.role
          }
        }, status: :ok
      end
    end
  end
end