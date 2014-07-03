class CommentSerializer < ActiveModel::Serializer
# cached
# delegate :cache_key, to: :object

  attributes :id, :body

  has_one :user, root: :author

end
