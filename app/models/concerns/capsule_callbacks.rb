class CapsuleCallbacks
  def self.before_save(capsule)
    capsule.hash_tags = capsule.title.split(/\s+|[;,]\s*/).select { |v| v[0] == '#' }.join(' ')

    capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
    capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
  end
end
