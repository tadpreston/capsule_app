class CommentSerializer < ActiveModel::Serializer
# cached
# delegate :cache_key, to: :object

  attributes :id, :body, :author

  def author
    CommentUserSerializer.new object.user, root: false
  end
end
