class NoCacheCapsuleSerializer < ActiveModel::Serializer
  attributes :watched_by, :is_read, :is_owned

  def watched_by
    object.watched_by? scope
  end

  def is_read
    object.read_by? scope
  end

  def is_owned
    if scope
      object.user_id == scope.id
    else
      false
    end
  end
end
