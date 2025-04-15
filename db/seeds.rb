puts "Cleaning database..."
Payment.delete_all
Appointment.delete_all
ProfessionalsSecretary.delete_all
Patient.delete_all
Professional.delete_all
User.delete_all
Clinic.delete_all

puts "Creating admin user..."
admin = User.create!(
  email: "admin@example.com",
  password: "password123",
  role: :admin,
  first_name: "Admin",
  last_name: "User"
)

puts "Creating Clinic 1: Clínica Dental del Sol..."
clinic1 = Clinic.create!(name: "Clínica Dental del Sol", address: "Chiclana 123, Bahia Blanca")

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

secretary1_user = User.create!(
  email: "secretary.sol@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Susana",
  last_name: "Fernández",
  clinic: clinic1
)
ProfessionalsSecretary.create!(professional: dentist1, secretary: secretary1_user)
ProfessionalsSecretary.create!(professional: dentist2, secretary: secretary1_user)
ProfessionalsSecretary.create!(professional: dentist3, secretary: secretary1_user)

patients_clinic1 = []
[dentist1, dentist2, dentist3].each_with_index do |dentist, dentist_index|
  num_patients = rand(10..15)
  num_patients.times do |i|
    patient_user = User.create!(
      email: "patient_c1_d#{dentist_index + 1}_#{i + 1}@example.com",
      password: "password123",
      role: :patient,
      first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
      last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
    )
    patient = Patient.create!(
      first_name: patient_user.first_name,
      last_name: patient_user.last_name,
      email: patient_user.email,
      professional: dentist.user,
      phone: "11#{rand(10000000..99999999)}"
    )
    patients_clinic1 << { patient: patient, dentist: dentist }
  end
end

puts "Creating Clinic 2: Clínica Sonrisa Perfecta..."
clinic2 = Clinic.create!(name: "Clínica Sonrisa Perfecta", address: "Florida 456, Bahia Blanca")

dentist4_user = User.create!(
  email: "dr.smith@example.com",
  password: "password123",
  role: :professional,
  first_name: "Robert",
  last_name: "Smith",
  clinic: clinic2
)
dentist4 = Professional.create!(user: dentist4_user, specialty: "dentist", clinic: clinic2, license_number: "LIC98765")

secretary2_user = User.create!(
  email: "secretary.sonrisa@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Liliana",
  last_name: "Hernández",
  clinic: clinic2
)
ProfessionalsSecretary.create!(professional: dentist4, secretary: secretary2_user)

patients_clinic2 = []
num_patients = rand(10..15)
num_patients.times do |i|
  patient_user = User.create!(
    email: "patient_c2_#{i + 1}@example.com",
    password: "password123",
    role: :patient,
    first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
    last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
  )
  patient = Patient.create!(
    first_name: patient_user.first_name,
    last_name: patient_user.last_name,
    email: patient_user.email,
    professional: dentist4.user,
    phone: "11#{rand(10000000..99999999)}"
  )
  patients_clinic2 << { patient: patient, dentist: dentist4 }
end

puts "Creating Clinic 3: Clínica Dientes Brillantes..."
clinic3 = Clinic.create!(name: "Clínica Dientes Brillantes", address: "Corrientes 789, Bahia Blanca")

dentist5_user = User.create!(
  email: "dr.martinez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Laura",
  last_name: "Martínez",
  clinic: clinic3
)
dentist5 = Professional.create!(user: dentist5_user, specialty: "dentist", clinic: clinic3, license_number: "LIC45678")

patients_clinic3 = []
num_patients = rand(10..15)
num_patients.times do |i|
  patient_user = User.create!(
    email: "patient_c3_#{i + 1}@example.com",
    password: "password123",
    role: :patient,
    first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
    last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
  )
  patient = Patient.create!(
    first_name: patient_user.first_name,
    last_name: patient_user.last_name,
    email: patient_user.email,
    professional: dentist5.user,
    phone: "11#{rand(10000000..99999999)}"
  )
  patients_clinic3 << { patient: patient, dentist: dentist5 }
end

puts "Creating Clinic 4: Centro Médico Integral..."
clinic4 = Clinic.create!(name: "Centro Médico Integral", address: "Sarmiento 101, Bahia Blanca")

general_practitioner_user = User.create!(
  email: "dr.gonzalez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Elena",
  last_name: "González",
  clinic: clinic4
)
general_practitioner = Professional.create!(user: general_practitioner_user, specialty: "general_practice", clinic: clinic4, license_number: "LIC11223")

cardiologist_user = User.create!(
  email: "dr.perez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Andrés",
  last_name: "Pérez",
  clinic: clinic4
)
cardiologist = Professional.create!(user: cardiologist_user, specialty: "cardiology", clinic: clinic4, license_number: "LIC33445")

pediatrician_user = User.create!(
  email: "dr.ramirez@example.com",
  password: "password123",
  role: :professional,
  first_name: "Sofía",
  last_name: "Ramírez",
  clinic: clinic4
)
pediatrician = Professional.create!(user: pediatrician_user, specialty: "pediatrics", clinic: clinic4, license_number: "LIC55667")

secretary4_user = User.create!(
  email: "secretary.integral@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Carolina",
  last_name: "Ruiz",
  clinic: clinic4
)
ProfessionalsSecretary.create!(professional: general_practitioner, secretary: secretary4_user)
ProfessionalsSecretary.create!(professional: cardiologist, secretary: secretary4_user)
ProfessionalsSecretary.create!(professional: pediatrician, secretary: secretary4_user)

patients_clinic4 = []
[general_practitioner, cardiologist, pediatrician].each_with_index do |professional, professional_index|
  num_patients = rand(10..15)
  num_patients.times do |i|
    patient_user = User.create!(
      email: "patient_c4_p#{professional_index + 1}_#{i + 1}@example.com",
      password: "password123",
      role: :patient,
      first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
      last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
    )
    patient = Patient.create!(
      first_name: patient_user.first_name,
      last_name: patient_user.last_name,
      email: patient_user.email,
      professional: professional.user,
      phone: "11#{rand(10000000..99999999)}"
    )
    patients_clinic4 << { patient: patient, professional: professional }
  end
end

puts "Creating Clinic 5: Clínica Salud Total..."
clinic5 = Clinic.create!(name: "Clínica Salud Total", address: "Belgrano 202, Bahia Blanca")

neurologist_user = User.create!(
  email: "dr.torres@example.com",
  password: "password123",
  role: :professional,
  first_name: "Miguel",
  last_name: "Torres",
  clinic: clinic5
)
neurologist = Professional.create!(user: neurologist_user, specialty: "neurology", clinic: clinic5, license_number: "LIC77889")

dermatologist_user = User.create!(
  email: "dr.molina@example.com",
  password: "password123",
  role: :professional,
  first_name: "Valentina",
  last_name: "Molina",
  clinic: clinic5
)
dermatologist = Professional.create!(user: dermatologist_user, specialty: "dermatology", clinic: clinic5, license_number: "LIC99001")

secretary5_user = User.create!(
  email: "secretary.salud@example.com",
  password: "password123",
  role: :secretary,
  first_name: "Beatriz",
  last_name: "Ortiz",
  clinic: clinic5
)
ProfessionalsSecretary.create!(professional: neurologist, secretary: secretary5_user)
ProfessionalsSecretary.create!(professional: dermatologist, secretary: secretary5_user)

patients_clinic5 = []
[neurologist, dermatologist].each_with_index do |professional, professional_index|
  num_patients = rand(10..15)
  num_patients.times do |i|
    patient_user = User.create!(
      email: "patient_c5_p#{professional_index + 1}_#{i + 1}@example.com",
      password: "password123",
      role: :patient,
      first_name: ["Lucía", "Martín", "Sofía", "Juan", "Ana", "Pedro", "Clara", "Diego", "Valeria", "Mateo"].sample,
      last_name: ["Gómez", "Rodríguez", "Fernández", "López", "Martínez", "Pérez", "García", "Sánchez", "Romero", "Díaz"].sample
    )
    patient = Patient.create!(
      first_name: patient_user.first_name,
      last_name: patient_user.last_name,
      email: patient_user.email,
      professional: professional.user,
      phone: "11#{rand(10000000..99999999)}"
    )
    patients_clinic5 << { patient: patient, professional: professional }
  end
end

puts "Creating appointments..."
all_patients = patients_clinic1 + patients_clinic2 + patients_clinic3 + patients_clinic4 + patients_clinic5

start_date = Date.today
business_days = []
current_date = start_date
while business_days.length < 30
  if current_date.monday? || current_date.tuesday? || current_date.wednesday? ||
     current_date.thursday? || current_date.friday?
    business_days << current_date
  end
  current_date += 1.day
end

available_hours = (9..18).to_a

all_patients.each_with_index do |patient_data, index|
  patient = patient_data[:patient]
  professional = patient_data[:professional] || patient_data[:dentist] 
  clinic = professional.clinic

  date = business_days[index % business_days.length]
  hour = available_hours[index % available_hours.length]

  Appointment.create!(
    patient: patient,
    professional: professional,
    clinic: clinic,
    date: date,
    time: Time.now.change(hour: hour, min: 0),
    status: "pending"
  )
end

puts "Seed data created successfully!"
puts "Created 5 clinics, 8 professionals, 3 secretaries, #{all_patients.count} patients, and #{all_patients.count} appointments."
puts "Admin user: admin@example.com / password123"
puts "Professionals: dr.alvarez@example.com, dr.sanchez@example.com, dr.lopez@example.com, dr.smith@example.com, dr.martinez@example.com, dr.gonzalez@example.com, dr.perez@example.com, dr.ramirez@example.com, dr.torres@example.com, dr.molina@example.com / password123"
puts "Secretaries: secretary.sol@example.com, secretary.sonrisa@example.com, secretary.integral@example.com, secretary.salud@example.com / password123"