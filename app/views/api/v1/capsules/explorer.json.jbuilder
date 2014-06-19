envelope(json, :success) do
  if @capsule_boxes[:capsules].size > 0
    json.capsule_count @capsule_boxes[:capsules].size
    json.set! :capsules do
      json.array! @capsule_boxes[:capsules] do |capsule|
        json.cache! ['api/v1/min_capsule', capsule] do
          json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
        end
      end
    end
  end
  if @capsule_boxes[:boxes]
    json.set! :boxes do
      json.array! @capsule_boxes[:boxes] do |box|
        json.cache! ['api/v1/boxes', box] do
          json.name box[:name]
          json.center_lat box[:center_lat]
          json.center_long box[:center_long]
          json.count box[:count]
        end
      end
    end
  end
end
