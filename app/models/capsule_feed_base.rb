class CapsuleFeedBase
  ATTRIBUTES = [:capsules, :metadata]
  attr_accessor *ATTRIBUTES + [:offset, :limit]

  def initialize offset, limit
    @offset = offset
    @limit = limit
  end

  def capsules
    capsule_scope.offset(offset).limit(limit)
  end

  def metadata
    {
      limit: limit,
      offset: offset,
      total: capsule_scope.count
    }
  end

  def read_attribute_for_serialization attribute
    send attribute
  end

  private

  def capsule_scope
    raise NotImplementedError
  end

end
