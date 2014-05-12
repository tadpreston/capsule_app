envelope(json, :success) do
  json.hashtags do
    json.array! @hashtags
  end
end
