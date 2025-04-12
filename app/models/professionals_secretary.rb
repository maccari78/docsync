class ProfessionalsSecretary < ApplicationRecord
  belongs_to :secretary, class_name: 'User'
  belongs_to :professional, inverse_of: :professionals_secretaries

  validates :secretary_id, presence: true
  validates :professional_id, presence: true
  validates :secretary_id,
            uniqueness: { scope: :professional_id, message: 'is already associated with this professional' }
end
