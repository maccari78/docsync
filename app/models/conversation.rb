class Conversation < ApplicationRecord
  belongs_to :appointment
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy
  validates :appointment_id, uniqueness: true
end
