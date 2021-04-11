class CapacityCalculator
  attr_accessor :responders, :result

  def initialize(responders)
    @responders = responders
    @result = {}
  end

  def self.call(responders)
    new(responders).calculate
  end

  def calculate
    responders.group_by(&:type).each do |key, values|
      result[key] = prepare_array(values)
    end
    result
  end

  def prepare_array(list)
    available = list.select { |elem| elem.emergency_code.nil? }
    on_duty = list.select(&:on_duty?)
    [list.sum(&:capacity), available.sum(&:capacity),
     on_duty.sum(&:capacity), (available & on_duty).sum(&:capacity)]
  end
end
