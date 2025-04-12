class Patient < ApplicationRecord
  belongs_to :professional, class_name: 'User', inverse_of: :patients_as_professional
  has_one_attached :photo
  has_many :appointments, dependent: :destroy, inverse_of: :patient
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def name
    "#{first_name} #{last_name}"
  end
end