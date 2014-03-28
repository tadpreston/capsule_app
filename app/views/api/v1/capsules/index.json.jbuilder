envelope(json, :success) do
  json.set! :capsules do
    json.message 'Hello from index!'
  end
end
