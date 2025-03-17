# Crear una clínica
clinic = Clinic.create!(name: "Dental Clinic 1", address: "123 Fake Street")

# Crear un usuario dentista y asociarlo con un Professional
dentist_user = User.create!(email: "dentist1@example.com", password: "password123", role: :professional, name: "Dr. Pérez", clinic: clinic)
professional = Professional.create!(user: dentist_user, specialty: :dentist)

# Crear un usuario secretario
secretary = User.create!(email: "secretary1@example.com", password: "password123", role: :secretary, name: "Ana Gómez", clinic: clinic)

# Crear 25 pacientes y asociarlos como Patient records
25.times do |i|
  patient_user = User.create!(email: "patient#{i+1}@example.com", password: "password123", role: :patient, name: "Patient #{i+1}")
  Patient.create!(name: patient_user.name, email: patient_user.email, professional: dentist_user, phone: "123456789#{i+1}")
end

# Crear turnos para los pacientes
patients = User.where(role: :patient).to_a
dentist_professional = Professional.find_by(user: dentist_user)

patients.each_with_index do |patient, index|
  # Crear un turno para cada paciente con el dentista
  Appointment.create!(
    patient: patient,
    professional: dentist_professional,
    clinic: clinic,
    date: Date.today + index.days,
    time: Time.now.change({ hour: 9 + (index % 8), min: 0 }),
    status: "pending"
  )
end

puts "Seed data created successfully! Created 1 clinic, 1 dentist, 1 secretary, 25 patients, and 25 appointments."