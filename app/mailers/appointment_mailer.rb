class AppointmentMailer < ApplicationMailer
  def confirmation_email(appointment)
    @appointment = appointment
    @patient = appointment.patient
    @professional = appointment.professional
    @user = @professional.user
    @clinic = appointment.clinic
    @google_calendar_url = google_calendar_url
    @google_maps_url = google_maps_url
    mail(to: @patient.email, subject: 'Your appointment was confirmed')
  end

  def post_appointment_email(appointment)
    @appointment = appointment
    @patient = appointment.patient
    @professional = appointment.professional
    @user = @professional.user
    @clinic = appointment.clinic
    mail(to: @patient.email, subject: 'Appointment details')
  end

  def payment_confirmation(appointment)
    @appointment = appointment
    @patient = appointment.patient
    @professional = appointment.professional
    @user = @professional.user
    @clinic = appointment.clinic
    mail(to: @patient.email, subject: "Pay confirmed - Appointment ##{appointment.id}")
  end

  private

  def google_calendar_url
    start_time = @appointment.date.to_time + @appointment.time.seconds_since_midnight
    end_time = start_time + 1.hour
    event_details = {
      text: "Dental appointment with #{@user.first_name} #{@user.last_name}",
      dates: "#{start_time.strftime('%Y%m%dT%H%M%S')}/#{end_time.strftime('%Y%m%dT%H%M%S')}",
      details: "Appointment in #{@clinic.name}, #{@clinic.address}",
      location: @clinic.address,
      add: 'reminder:15'
    }
    "https://www.google.com/calendar/render?action=TEMPLATE&#{event_details.to_query}"
  end

  def google_maps_url
    "https://www.google.com/maps/dir/?api=1&destination=#{URI.encode_www_form_component(@clinic.address)}"
  end
end
