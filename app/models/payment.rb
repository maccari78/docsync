class Payment < ApplicationRecord
  belongs_to :appointment

  enum :status, { pending: 0, approved: 1, rejected: 2 }
end
