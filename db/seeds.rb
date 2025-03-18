clinic = Clinic.create!(name: "Dental Clinic 1", address: "123 Fake Street")
dentist_user = User.create!(email: "dentist1@example.com", password: "password123", role: :professional, name: "Dr. Pérez", clinic: clinic)
professional = Professional.create!(user: dentist_user, specialty: :dentist)
secretary = User.create!(email: "secretary1@example.com", password: "password123", role: :secretary, name: "Ana Gómez", clinic: clinic)
15.times do |i|
  patient_user = User.create!(email: "patient#{i+1}@example.com", password: "password123", role: :patient, name: "Patient #{i+1}")
  Patient.create!(name: patient_user.name, email: patient_user.email, professional: dentist_user, phone: "123456789#{i+1}")
end

patients = User.where(role: :patient).to_a
dentist_professional = Professional.find_by(user: dentist_user)

patients.each_with_index do |patient, index|
  Appointment.create!(
    patient: patient,
    professional: dentist_professional,
    clinic: clinic,
    date: Date.today + index.days,
    time: Time.now.change({ hour: 9 + (index % 8), min: 0 }),
    status: "pending"
  )
end

puts "Seed data created successfully! Created 1 clinic, 1 dentist, 1 secretary, 15 patients, and 15 appointments."

# Paso 3: Dropear y recrear la base
# Ahora que routes.rb no depende de User, probá de nuevo:
# bash

# - rails db:drop
# - rails db:create
# - rails db:migrate
# - rails db:seed

