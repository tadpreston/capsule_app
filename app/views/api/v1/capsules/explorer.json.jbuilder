envelope(json, :success) do
  if @capsule_boxes[:capsules].size > 0
    json.capsule_count @capsule_boxes[:capsules].size
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
        else
          unless capsule.lock_answer.blank?
            json.lock_answer capsule.lock_answer
          end
        end
        json.is_watched capsule.watched_by?(current_user)
        json.is_read capsule.read_by?(current_user)
        json.is_owned is_owned?(capsule.user_id)
      end
    end
  end
  if @capsule_boxes[:boxes]
    json.set! :boxes do
      json.array! @capsule_boxes[:boxes] do |box|
        json.cache! ['api/v1/boxes', box] do
          json.partial! 'api/v1/capsules/capsule_box', box: box
        end
      end
    end
  end
end
