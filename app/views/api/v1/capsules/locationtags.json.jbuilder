envelope(json, :success) do
  json.capsule_count @capsules.count(:all)
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.partial! 'api/v1/capsules/capsule', capsule: capsule
    end
  end
end
