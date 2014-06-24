envelope(json, :success) do
  json.set! :boxes do
    json.array! @boxes do |box|
      json.cache! ['api/v1/boxes', box] do
        json.partial! 'api/v1/capsules/capsule_box', box: box
      end
    end
  end
end
