# db/seeds.rb

# Limpiar la base de datos antes de crear nuevos datos
puts "Cleaning database..."
User.destroy_all
Professional.destroy_all
Patient.destroy_all
Appointment.destroy_all
Clinic.destroy_all

# Crear Clínica 1: "Clínica Dental del Sol" con 3 odontólogos y 1 secretaria
puts "Creating Clinic 1: Clínica Dental del Sol..."
clinic1 = Clinic.create!(name: "Clínica Dental del Sol", address: "Av. Libertador 123, Buenos Aires")

# Odontólogos para Clínica 1
dentist1_user = User.create!(
  email: "dr.alvarez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Carlos",
  last_name: "Álvarez",
  clinic: clinic1
)
dentist1 = Professional.create!(user: dentist1_user, specialty: "dentist", clinic: clinic1, license_number: "LIC12345")

dentist2_user = User.create!(
  email: "dr.sanchez@example.com",
  password: "password123",
  role: :professional,
  first_name: "María",
  last_name: "Sánchez",
  clinic: clinic1
)
dentist2 = Professional.create!(user: dentist2_user, specialty: "dentist", clinic: clinic1, license_number: "LIC67890")

dentist3_user = User.create!(
  email: "dr.lopez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Javier",
  last_name: "López",
  clinic: clinic1
)
dentist3 = Professional.create!(user: dentist3_user, specialty: "dentist", clinic: clinic1, license_number: "LIC54321")

# Secretaria para Clínica 1
secretary1_user = User.create!(
  email: "secretary.sol@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Susana",
  last_name: "Fernández",
  clinic: clinic1
)
secretary1 = ProfessionalsSecretary.create!(professional: dentist1, secretary: secretary1_user)
ProfessionalsSecretary.create!(professional: dentist2, secretary: secretary1_user)
ProfessionalsSecretary.create!(professional: dentist3, secretary: secretary1_user)

# Pacientes para los odontólogos de Clínica 1
patients_clinic1 = []
[dentist1, dentist2, dentist3].each_with_index do |dentist, dentist_index|
  num_patients = rand(5..10) # Entre 5 y 10 pacientes por odontólogo
  num_patients.times do |i|
    patient_user = User.create!(
      email: "patient#{dentist_index * 10 + i + 1}@example.com",
      password: "password123",
      role: :patient,
      first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
      last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
    )
    patient = Patient.create!(
      name: "#{patient_user.first_name} #{patient_user.last_name}",
      email: patient_user.email,
      professional: dentist.user,
      phone: "11#{rand(10000000..99999999)}"
    )
    patients_clinic1 << { patient: patient_user, dentist: dentist }
  end
end

# Crear Clínica 2: "Clínica Sonrisa Perfecta" con 1 odontólogo y 1 secretaria
puts "Creating Clinic 2: Clínica Sonrisa Perfecta..."
clinic2 = Clinic.create!(name: "Clínica Sonrisa Perfecta", address: "Calle Florida 456, Buenos Aires")

# Odontólogo para Clínica 2
dentist4_user = User.create!(
  email: "dr.smith@example.com",
  password: "password123",
  role: :professional,
  first_name: "Robert",
  last_name: "Smith",
  clinic: clinic2
)
dentist4 = Professional.create!(user: dentist4_user, specialty: "dentist", clinic: clinic2, license_number: "LIC98765")

# Secretaria para Clínica 2
secretary2_user = User.create!(
  email: "secretary.sonrisa@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Liliana",
  last_name: "Hernández",
  clinic: clinic2
)
secretary2 = ProfessionalsSecretary.create!(professional: dentist4, secretary: secretary2_user)

# Pacientes para el odontólogo de Clínica 2
patients_clinic2 = []
num_patients = rand(5..10)
num_patients.times do |i|
  patient_user = User.create!(
    email: "patient_clinic2_#{i + 1}@example.com",
    password: "password123",
    role: :patient,
    first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
    last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
  )
  patient = Patient.create!(
    name: "#{patient_user.first_name} #{patient_user.last_name}",
    email: patient_user.email,
    professional: dentist4.user,
    phone: "11#{rand(10000000..99999999)}"
  )
  patients_clinic2 << { patient: patient_user, dentist: dentist4 }
end

# Crear Clínica 3: "Clínica Dientes Brillantes" con 1 odontólogo y sin secretaria
puts "Creating Clinic 3: Clínica Dientes Brillantes..."
clinic3 = Clinic.create!(name: "Clínica Dientes Brillantes", address: "Av. Corrientes 789, Buenos Aires")

# Odontólogo para Clínica 3
dentist5_user = User.create!(
  email: "dr.martinez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Laura",
  last_name: "Martínez",
  clinic: clinic3
)
dentist5 = Professional.create!(user: dentist5_user, specialty: "dentist", clinic: clinic3, license_number: "LIC45678")

# Pacientes para el odontólogo de Clínica 3
patients_clinic3 = []
num_patients = rand(5..10)
num_patients.times do |i|
  patient_user = User.create!(
    email: "patient_clinic3_#{i + 1}@example.com",
    password: "password123",
    role: :patient,
    first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
    last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
  )
  patient = Patient.create!(
    name: "#{patient_user.first_name} #{patient_user.last_name}",
    email: patient_user.email,
    professional: dentist5.user,
    phone: "11#{rand(10000000..99999999)}"
  )
  patients_clinic3 << { patient: patient_user, dentist: dentist5 }
end

# Crear turnos para los pacientes de todas las clínicas
puts "Creating appointments..."
all_patients = patients_clinic1 + patients_clinic2 + patients_clinic3
all_patients.each_with_index do |patient_data, index|
  patient = patient_data[:patient]
  dentist = patient_data[:dentist]
  clinic = dentist.clinic

  # Crear turnos distribuidos en los próximos 30 días
  date = Date.today + (index % 30).days
  hour = 9 + (index % 8) # Horas entre 9:00 y 16:00
  Appointment.create!(
    patient: patient,
    professional: dentist,
    clinic: clinic,
    date: date,
    time: Time.now.change(hour: hour, min: 0),
    status: "pending"
  )
end

# Crear un usuario admin para pruebas
puts "Creating admin user..."
User.create!(
  email: "admin@example.com",
  password: "password123",
  role: :admin,
  first_name: "Admin",
  last_name: "User"
)

puts "Seed data created successfully!"
puts "Created 3 clinics, 5 dentists, 2 secretaries, #{all_patients.count} patients, and #{all_patients.count} appointments."
puts "Admin user: admin@example.com / password123"
puts "Dentists: dr.alvarez@example.com, dr.sanchez@example.com, dr.lopez@example.com, dr.smith@example.com, dr.martinez@example.com / password123"
puts "Secretaries: secretary.sol@example.com, secretary.sonrisa@example.com / password123"