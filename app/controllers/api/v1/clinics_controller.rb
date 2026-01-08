# app/controllers/api/v1/clinics_controller.rb
module Api
  module V1
    class ClinicsController < BaseController
      # GET /api/v1/clinics
      def index
        clinics = Clinic.all
        
        render json: clinics.map { |clinic|
          {
            id: clinic.id,
            name: clinic.name,
            address: clinic.address
          }
        }
      end
    end
  end
end