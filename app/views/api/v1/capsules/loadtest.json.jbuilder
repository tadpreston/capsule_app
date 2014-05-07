envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.cache! ['v1', capsule], expires_in: 10.minutes do
        json.id capsule.id
        json.title capsule.title
        json.set! :hash_tags, capsule.hash_tags_array
        json.set! :creator do
#          json.id capsule.user.id
#          json.email capsule.user.email
#          json.full_name capsule.user_full_name
        end
      end
    end
  end
end
