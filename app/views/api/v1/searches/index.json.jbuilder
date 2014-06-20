envelope(json, :success) do
  unless @users.empty?
    json.set! :users do
      json.array! @users do |user|
        json.cache! ['api/v1/search', user] do
          json.id user.id
          json.email user.email
          json.username user.username
          json.full_name user.full_name
          json.first_name user.first_name
          json.last_name user.last_name
          json.phone_number user.phone_number || ''
          json.location user.location
          json.locale user.locale
          json.timezone user.time_zone || ''
          json.provider user.provider || ''
          json.uid user.uid || ''
          json.profile_image user.profile_image || ''
          json.tutorial_progress user.tutorial_progress
          json.settings user.settings
          json.email_confirmed (user.confirmed? ? true : false)
          json.created_at user.created_at
          json.updated_at user.updated_at
        end
      end
    end
  end
  unless @capsules.empty?
    json.set! :capsules do
      json.array! @capsules do |capsule|
        json.cache! ['api/v1/search', capsule] do
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
