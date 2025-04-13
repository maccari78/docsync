class DebugController < ApplicationController
  skip_before_action :authenticate_user!, only: [:appointments]

  def appointments
    @appointments = Appointment.where(date: Date.parse("2025-04-13"))
    @danilo = User.find_by(email: "maccari78@gmail.com")
    @danilo_appointments = Appointment.where(patient_id: @danilo.id, date: Date.parse("2025-04-13"))
  end
end