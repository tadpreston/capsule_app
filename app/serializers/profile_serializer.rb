class ProfileSerializer < ActiveModel::Serializer
  def serializable_hash
    min_capsule_serializer_hash.merge no_cache_capsule_serializer_hash
  end

  private

    def min_capsule_serializer_hash
      MinCapsuleSerializer.new(object, options).serializable_hash
    end

    def no_cache_capsule_serializer_hash
      NoCacheCapsuleSerializer.new(object, options).serializable_hash
    end
end
