module API
  module V1a
    class CapsuleFeedSerializer < ActiveModel::Serializer
      attributes *(Feed::ATTRIBUTES)
      delegate :current_user, to: :scope

      def capsules
        object.capsules.map { |capsule| API::V1a::CapsuleSerializer.new capsule, scope: scope, root: false }
      end
    end
  end
end
