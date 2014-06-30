envelope(json, :success) do
  json.set! :boxes do
    json.array! @boxes do |box|
      json.partial! 'api/v1/capsules/capsule_box', box: box
#      json.cache! ['api/v1/boxes', box] do
#      end
    end
  end
end
