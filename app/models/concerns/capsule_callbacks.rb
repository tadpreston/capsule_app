class CapsuleCallbacks
  def self.before_save(capsule)
    capsule.hash_tags = capsule.title.split(/\s+|[;,]\s*/).select { |v| v[0] == '#' }.join(' ')
  end
end
