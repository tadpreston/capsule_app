envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
#      json.cache! ['api/v1/_min_capsule', capsule] do
#      end
    end
  end
end
