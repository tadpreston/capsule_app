module API
  module V1a
    class CapsuleForwardSerializer < ActiveModel::Serializer
      attributes :capsules, :links

      def capsules
        object.capsules.map { |capsule| API::V1a::CapsuleSerializer.new capsule, scope: scope, root: false }
      end

      def links
        object.links.map { |link| API::V1a::ForwardLinkSerializer.new link, root: false }
      end
    end
  end
end

