module API
  module V1a
    class CommentSerializer < ActiveModel::Serializer
    # cached
    # delegate :cache_key, to: :object

      attributes :id, :body, :author

      def author
        API::V1a::CommentUserSerializer.new object.user, root: false
      end
    end
  end
end
