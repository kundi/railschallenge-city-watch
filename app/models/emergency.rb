class Emergency < ApplicationRecord
  self.primary_key = 'code'

  has_many :responders, foreign_key: :emergency_code
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :dispatch_among_responders
  after_update :release_the_responders, if: -> { resolved_at_changed? }

  def self.calculate_full_response_ration
    total_fully_responded_responders = Responder.where(on_duty: true).sum(:capacity)
    return nil if total_fully_responded_responders.zero?

    [total_fully_responded_responders, Emergency.all.count]
  end

  private

  def dispatch_among_responders
    Dispatcher.call(self)
  end

  def release_the_responders
    return if resolved_at.nil?

    responders.update_all(emergency_code: nil)
  end
end
