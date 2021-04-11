class Dispatcher
  attr_accessor :emergency, :fire_responders, :police_responders, :medical_responders

  def initialize(emergency)
    @emergency = emergency
    responders = Responder.available.where(on_duty: true)
    @fire_responders = responders.where(type: 'Fire').order(capacity: :desc)
    @police_responders = responders.where(type: 'Police').order(capacity: :desc)
    @medical_responders = responders.where(type: 'Medical').order(capacity: :desc)
  end

  def self.call(emergency)
    new(emergency).dispatch
  end

  def dispatch
    fire_dispatcher(fire_responders, emergency.fire_severity)
    police_dispatcher(police_responders, emergency.police_severity)
    medical_dispatcher(medical_responders, emergency.medical_severity)
  end

  def fire_dispatcher(fire_responders, fire_severity)
    fire_responders.each do |fire_resp|
      if fire_resp.capacity <= fire_severity
        fire_resp.update!(emergency_code: emergency.code)
        fire_severity -= fire_resp.capacity
      end
    end
  end

  def police_dispatcher(police_responders, police_severity)
    police_responders.each do |police_resp|
      if police_resp.capacity <= police_severity
        police_resp.update!(emergency_code: emergency.code)
        police_severity -= police_resp.capacity
      end
    end
  end

  def medical_dispatcher(medical_responders, medical_severity)
    medical_responders.each do |medical_resp|
      if medical_resp.capacity <= medical_severity
        medical_resp.update!(emergency_code: emergency.code)
        medical_severity -= medical_resp.capacity
      end
    end
  end
end
