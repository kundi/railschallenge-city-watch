class Emergency < ApplicationRecord
  self.primary_key = 'code'
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.calculate_full_response_ration
    total_emergencies = Emergency.all.count
    total_fully_responded_responders = Responder.where(on_duty: true).sum(:capacity)
    [total_fully_responded_responders, total_emergencies]
  end
end
