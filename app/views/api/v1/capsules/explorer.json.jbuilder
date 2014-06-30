envelope(json, :success) do
  if @capsule_boxes[:capsules].size > 0
    json.capsule_count @capsule_boxes[:capsules].size
    json.set! :capsules do
      json.array! @capsule_boxes[:capsules] do |capsule|
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
#        json.cache! ['api/v1/_min_capsule', capsule] do
#        end
      end
    end
  end
  if @capsule_boxes[:boxes]
    json.set! :boxes do
      json.array! @capsule_boxes[:boxes] do |box|
        json.partial! 'api/v1/capsules/capsule_box', box: box
#        json.cache! ['api/v1/boxes', box] do
#        end
      end
    end
  end
end
