envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsule_boxes[:capsules] do |capsule|
      json.cache! ['api/v1/_min_capsule', capsule] do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
      json.is_watched capsule.watched_by?(current_user)
      json.is_read capsule.read_by?(current_user)
      json.is_owned is_owned?(capsule.user_id)
    end
  end
end
