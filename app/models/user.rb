class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)
    if user
      user.update(provider: auth.provider, uid: auth.uid) if user.provider.nil? || user.uid.nil?
      return user
    end

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name || 'Unknown'
      user.last_name = auth.info.last_name || 'User'
      user.role = 'patient'
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  belongs_to :clinic, optional: true, inverse_of: :users
  has_one :professional, dependent: :destroy, inverse_of: :user
  has_many :appointments_as_patient, class_name: 'Appointment', foreign_key: 'patient_id', inverse_of: :patient
  has_many :appointments_as_professional, through: :professional, source: :appointments
  has_many :patients_as_professional, foreign_key: 'professional_id', class_name: 'Patient'
  has_many :professionals_secretaries, foreign_key: :secretary_id, dependent: :destroy
  has_many :professionals, through: :professionals_secretaries
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id' 
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id' 
  has_many :messages 

  enum :role, { patient: 0, secretary: 1, professional: 2, admin: 3 }, default: :patient

  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  def professional
    super if role == 'professional'
  end

  def name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      email.split('@').first
    end
  end

  # JWT Token generation
  def generate_jwt
    payload = {
      user_id: id,
      email: email,
      role: role,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, JWT_SECRET, JWT_ALGORITHM)
  end
end
