envelope(json, :success) do
  json.set! :forme do
    json.array! @capsules_forme do |capsule|
      json.cache! ['api/v1/_min_capsule', capsule] do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
    end
  end
  json.set! :suggested do
    json.array! @suggested_capsules do |capsule|
      json.cache! ['api/v1/_min_capsule', capsule] do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
    end
  end
  json.set! :by_me do
    json.array! @user_capsules do |capsule|
      json.cache! ['api/v1/_min_capsule', capsule] do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
    end
  end
end
