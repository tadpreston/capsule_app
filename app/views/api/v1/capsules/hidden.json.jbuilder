envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.cache! ['_capsule', capsule], expires_in: 30.minutes do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
    end
  end
end
