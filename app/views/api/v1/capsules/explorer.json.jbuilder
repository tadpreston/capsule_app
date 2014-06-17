envelope(json, :success) do
  if @capsule_boxes[:capsules].size > 0
    json.capsule_count @capsule_boxes[:capsules].size
    json.set! :capsules do
      json.array! @capsule_boxes[:capsules] do |capsule|
        json.cache! ['_capsule', capsule], expires_in: 30.minutes do
          json.id capsule.id
          json.title capsule.title
          json.set! :hash_tags, capsule.hash_tags.split(' ')
          json.location capsule.location
          json.relative_location capsule.relative_location
          json.thumbnail capsule.thumbnail_path
          json.is_watched capsule.watched_by?(current_user)
          json.is_incognito capsule.incognito || false
          json.is_read capsule.read_by?(current_user)
          json.is_portable capsule.is_portable || false
          json.is_owned is_owned?(capsule.user_id)
        end
      end
    end
  end
  if @capsule_boxes[:boxes]
    json.set! :boxes do
      json.array! @capsule_boxes[:boxes] do |box|
        json.cache! ['boxV1', box], expires_in: 30.minutes do
          json.name box[:name]
          json.center_lat box[:center_lat]
          json.center_long box[:center_long]
          json.count box[:count]
        end
      end
    end
  end
end
