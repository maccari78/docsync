class Appointment < ApplicationRecord
  belongs_to :patient, class_name: "User"
  belongs_to :professional
  belongs_to :clinic
end