envelope(json, :success) do
  json.set! :capsules do
    json.message 'Hello from show!'
  end
end
