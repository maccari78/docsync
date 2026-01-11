# app/controllers/api/v1/appointments_controller.rb
module Api
  module V1
    class AppointmentsController < BaseController
      # GET /api/v1/appointments
      def index
        appointments = case current_api_user.role
        when 'admin'
          Appointment.where(deleted_at: nil).includes(:patient, :professional, :clinic, conversation: :messages).all
        when 'professional'
          current_api_user.appointments_as_professional.where(deleted_at: nil).includes(:patient, :clinic, conversation: :messages)
        when 'secretary'
          # Secretary sees appointments from their clinic
          if current_api_user.clinic_id
            Appointment.where(clinic_id: current_api_user.clinic_id, deleted_at: nil).includes(:patient, :professional, :clinic, conversation: :messages)
          else
            []
          end
        when 'patient'
          # Encontrar el registro Patient asociado al usuario
          patient = Patient.find_by(email: current_api_user.email)
          patient ? patient.appointments.where(deleted_at: nil).includes(:professional, :clinic, conversation: :messages) : []
        else
          []
        end

        render json: appointments.map { |apt| serialize_appointment(apt) }
      end

      # POST /api/v1/appointments
      def create
        appointment = Appointment.new(create_appointment_params)

        # Set defaults based on user role
        case current_api_user.role
        when 'patient'
          # Patient creating their own appointment
          patient = Patient.find_by(email: current_api_user.email)
          unless patient
            render json: { error: 'Patient record not found' }, status: :not_found
            return
          end
          appointment.patient = patient
          appointment.status = 'pending'
        when 'professional'
          # Professional can only create appointments for themselves
          unless current_api_user.professional
            render json: { error: 'Professional record not found' }, status: :not_found
            return
          end
          # Force professional_id to be the current user's professional record
          appointment.professional_id = current_api_user.professional.id
          appointment.status = params[:appointment][:status] || 'pending'
        when 'admin', 'secretary'
          # Admin/Secretary can create for any patient
          appointment.status = params[:appointment][:status] || 'pending'
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
          return
        end
        
        if appointment.save
          render json: serialize_appointment(appointment), status: :created
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # GET /api/v1/appointments/:id
      def show
        appointment = find_appointment
        return unless appointment
        
        render json: serialize_appointment(appointment)
      end

      # PATCH/PUT /api/v1/appointments/:id
      def update
        appointment = find_appointment
        return unless appointment
        
        if appointment.update(appointment_params)
          render json: serialize_appointment(appointment), status: :ok
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/appointments/:id/confirm
      def confirm
        appointment = find_appointment
        return unless appointment
        
        if appointment.update(status: 'confirmed')
          render json: serialize_appointment(appointment), status: :ok
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/appointments/:id/cancel
      def cancel
        appointment = find_appointment
        return unless appointment
        
        if appointment.update(status: 'cancelled')
          render json: serialize_appointment(appointment), status: :ok
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/appointments/:id/complete
      def complete
        appointment = find_appointment
        return unless appointment
        
        if appointment.update(status: 'completed')
          render json: serialize_appointment(appointment), status: :ok
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/appointments/availability?professional_id=X&date=2024-01-09
      def availability
        professional_id = params[:professional_id]
        date = Date.parse(params[:date])
        
        # Obtener turnos ocupados para ese profesional en esa fecha
        occupied_times = Appointment
          .where(professional_id: professional_id, date: date, deleted_at: nil)
          .where.not(status: 'cancelled')
          .pluck(:time)
          .map { |time| time.strftime('%H:%M') }
        
        # Horarios posibles
        all_time_slots = [
          '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
          '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00'
        ]
        
        # Horarios disponibles
        available_times = all_time_slots - occupied_times
        
        render json: {
          date: date,
          professional_id: professional_id,
          occupied: occupied_times,
          available: available_times
        }
      end
      
      private
      
      def find_appointment
        appointment = Appointment.includes(:patient, :professional, :clinic, conversation: :messages).find_by(id: params[:id])

        unless appointment && can_access_appointment?(appointment)
          render json: { error: 'Appointment not found' }, status: :not_found
          return nil
        end

        appointment
      end
      
      def can_access_appointment?(appointment)
        case current_api_user.role
        when 'admin'
          true
        when 'professional'
          current_api_user.professional && appointment.professional_id == current_api_user.professional.id
        when 'patient'
          patient = Patient.find_by(email: current_api_user.email)
          patient && appointment.patient_id == patient.id
        else
          false
        end
      end

      def serialize_appointment(appointment)
        {
          id: appointment.id,
          date: appointment.date,
          time: appointment.time&.strftime('%H:%M'),
          status: appointment.status,
          treatment_details: appointment.treatment_details,
          prescription: appointment.prescription,
          patient: {
            id: appointment.patient.id,
            name: appointment.patient.name,
            email: appointment.patient.email
          },
          professional: {
            id: appointment.professional.id,
            name: "#{appointment.professional.user.first_name} #{appointment.professional.user.last_name}",
            email: appointment.professional.user.email,
            specialty: appointment.professional.specialty
          },
          clinic: {
            id: appointment.clinic.id,
            name: appointment.clinic.name,
            address: appointment.clinic.address
          },
          conversation: appointment.conversation ? {
            id: appointment.conversation.id,
            has_messages: appointment.conversation.messages.any?,
            message_count: appointment.conversation.messages.count
          } : nil
        }
      end

      def appointment_params
        params.require(:appointment).permit(:status, :treatment_details, :prescription)
      end

      def create_appointment_params
        permitted = params.require(:appointment).permit(
          :patient_id,
          :professional_id,
          :clinic_id,
          :date,
          :time,
          :treatment_details
        )

        # Fix timezone issue - convert date string to Date object
        if permitted[:date].present?
          permitted[:date] = Date.parse(permitted[:date])
        end

        permitted
      end
    end
  end
end