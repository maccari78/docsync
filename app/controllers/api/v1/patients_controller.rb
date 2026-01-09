# app/controllers/api/v1/patients_controller.rb
module Api
  module V1
    class PatientsController < BaseController
      # GET /api/v1/patients
      def index
        patients = case current_api_user.role
        when 'admin'
          Patient.all
        when 'professional'
          current_api_user.patients_as_professional
        when 'secretary'
          # Secretaria ve pacientes de su clínica
          current_api_user.clinic.appointments.includes(:patient).map(&:patient).uniq
        else
          []
        end
        
        render json: patients.map { |patient|
          {
            id: patient.id,
            name: patient.name,
            email: patient.email,
            phone: patient.phone
          }
        }
      end
    end
  end
end