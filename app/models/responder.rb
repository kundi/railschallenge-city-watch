class Responder < ApplicationRecord
  self.inheritance_column = nil
  self.primary_key = 'name'
  belongs_to :emergency, foreign_key: :emergency_code
  validates :type, :name, :capacity, presence: true
  validates :name, uniqueness: true
  validates :capacity, inclusion: { in: 1..5, message: 'is not included in the list' }
end
