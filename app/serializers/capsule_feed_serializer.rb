class CapsuleFeedSerializer < ActiveModel::Serializer
  attributes *(Feed::ATTRIBUTES)
  delegate :current_user, to: :scope

  def capsules
    object.capsules.map { |capsule| CapsuleSerializer.new capsule, scope: scope, root: false }
  end
end
