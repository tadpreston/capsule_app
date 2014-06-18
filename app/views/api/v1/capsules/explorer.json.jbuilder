envelope(json, :success) do
  if @capsule_boxes[:capsules].size > 0
    json.capsule_count @capsule_boxes[:capsules].size
    json.set! :capsules do
      json.array! @capsule_boxes[:capsules] do |capsule|
        json.cache! ['_capsule', capsule], expires_in: 30.minutes do
          json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
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
