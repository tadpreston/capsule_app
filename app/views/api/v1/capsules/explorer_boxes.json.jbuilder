envelope(json, :success) do
  json.set! :boxes do
    json.array! @boxes do |box|
      json.cache! ['boxV1', box], expires_in: 30.minutes do
        json.name box[:name]
        json.center_lat box[:center_lat]
        json.center_long box[:center_long]
        json.count box[:count]
      end
    end
  end
end
