envelope(json, :success) do
  json.set! :watched do
    json.array! @watched_capsules do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.partial! 'api/v1/capsules/capsule', capsule: capsule
      end
    end
  end
  json.set! :forme do
    json.array! @capsules_forme do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.partial! 'api/v1/capsules/capsule', capsule: capsule
      end
    end
  end
  json.set! :suggested do
    json.array! @suggested_capsules do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.partial! 'api/v1/capsules/capsule', capsule: capsule
      end
    end
  end
end
