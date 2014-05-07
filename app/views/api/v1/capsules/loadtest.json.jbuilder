envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.id capsule.id
        json.title capsule.title
      end
    end
  end
end
