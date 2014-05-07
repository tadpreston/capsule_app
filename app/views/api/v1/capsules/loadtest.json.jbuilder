envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.partial! 'api/v1/capsules/capsule', capsule: capsule
#      json.cache! ['v1', capsule], expires_in: 10.minutes do
#      end
    end
  end
end
