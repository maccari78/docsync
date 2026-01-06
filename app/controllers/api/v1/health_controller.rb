# app/controllers/api/v1/health_controller.rb
module Api
  module V1
    class HealthController < BaseController
      skip_before_action :authenticate_api_user!
      
      def index
        render json: { 
          status: 'ok', 
          message: 'DocSync API is running',
          version: '1.0.0',
          timestamp: Time.current
        }
      end
    end
  end
end