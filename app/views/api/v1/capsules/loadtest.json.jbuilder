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
        json.location capsule.location
        json.relative_location capsule.relative_location
        json.payload_type capsule.payload_type || 0
        json.status capsule.status
        json.promotional_state capsule.promotional_state || 0
        json.thumbnail capsule.thumbnail
        json.set! :assets, capsule.assets
        json.start_date '2014-04-02T11:12:13'
        json.lock_question capsule.lock_question
        json.lock_answer capsule.lock_answer
        json.is_watched capsule.watched || false
        json.is_incognito capsule.incognito || false
#       json.is_read capsule.read_by?(current_user)
        json.created_at capsule.created_at
        json.updated_at capsule.updated_at
      end
    end
  end
end
