if @show_capacity && @show_capacity == 'capacity'
  json.capacity @capacities
else
  json.responders do
    json.array! @responders do |responder|
      json.type responder.type
      json.name responder.name
      json.capacity responder.capacity
      json.on_duty responder.on_duty
      json.emergency_code responder.emergency_code
    end
  end
end
