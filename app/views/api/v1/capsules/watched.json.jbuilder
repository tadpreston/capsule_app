envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsule_boxes[:capsules] do |capsule|
      json.cache! ['api/v1/_min_capsule', capsule] do
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
      end
      unless capsule.start_date.nil?
        json.start_date capsule.start_date
      end
      unless capsule.lock_question.blank?
        json.lock_question capsule.lock_question
        json.lock_answer capsule.lock_answer
      end
      json.is_watched capsule.watched_by?(current_user)
      json.is_read capsule.read_by?(current_user)
      json.is_owned is_owned?(capsule.user_id)
    end
  end
end
