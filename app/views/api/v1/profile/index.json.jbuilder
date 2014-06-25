envelope(json, :success) do
  json.set! :byme do
    json.set! :capsules do
      json.array! @capsules do |capsule|
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
    end
    json.set! :watched do
      json.set! :capsules do
        json.array! @watched_capsules do |capsule|
          json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
        end
      end
      json.set! :locations do
        json.array! @watched_locations do |location|
          json.partial! 'api/v1/location_watches/location_watch', location_watch: location
        end
      end
      json.set! :following do
        json.array! @following do |user|
          json.partial! 'api/v1/users/array_user', user: user
        end
      end
    end
    json.set! :followers do
      json.array! @followers do |user|
        json.partial! 'api/v1/users/array_user', user: user
      end
    end
  end
end
