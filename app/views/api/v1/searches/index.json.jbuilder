envelope(json, :success) do
  unless @users.empty?
    json.set! :users do
      json.array! @users do |user|
        json.partial! 'api/v1/users/user', user: user
      end
    end
  end
  unless @capsules.empty?
    json.set! :capsules do
      json.array! @capsules do |capsule|
        json.cache! ['v1', capsule], expires_in: 10.minutes do
          json.partial! 'api/v1/capsules/capsule', capsule: capsule
        end
      end
    end
  end
  if @hashtags.size > 0
    json.set! :hashtags do
      json.array! @hashtags do |hashtag|
        json.tag hashtag.tag
        json.latitude hashtag.latitude
        json.longitude hashtag.longitude
      end
    end
  end
end
