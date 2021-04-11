json.responder do
  json.type @responder.type
  json.name @responder.name
  json.capacity @responder.capacity
  json.on_duty @responder.on_duty
  json.emergency_code @responder.emergency_code
end
