# app/controllers/api/v1/professionals_controller.rb
module Api
  module V1
    class ProfessionalsController < BaseController
      # GET /api/v1/professionals
      def index
        professionals = Professional.includes(:user, :clinic).all
        
        render json: professionals.map { |prof|
          {
            id: prof.id,
            name: "#{prof.user.first_name} #{prof.user.last_name}",
            email: prof.user.email,
            specialty: prof.specialty,
            clinic: {
              id: prof.clinic.id,
              name: prof.clinic.name
            }
          }
        }
      end
    end
  end
end