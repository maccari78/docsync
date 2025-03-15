clinic = Clinic.create!(name: "Dental Clinic 1", address: "123 Fake Street")
dentist_user = User.create!(email: "dentist1@example.com", password: "password123", role: :professional, name: "Dr. Pérez", clinic: clinic)
Professional.create!(user: dentist_user, specialty: :dentist)
secretary = User.create!(email: "secretary1@example.com", password: "password123", role: :secretary, name: "Ana Gómez", clinic: clinic)
25.times do |i|
  User.create!(email: "patient#{i+1}@example.com", password: "password123", role: :patient, name: "Patient #{i+1}")
end
