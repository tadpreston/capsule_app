envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.partial! 'api/v1/capsules/capsule', capsule: capsule
      end
    end
  end
end
