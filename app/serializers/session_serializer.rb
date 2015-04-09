class SessionSerializer < ActiveModel::Serializer
# cached
# delegate :cache_key, to: :object

  attributes :authentication_token, :user

  def authentication_token
    object.current_device.auth_token
  end

  def user
    UserSerializer.new object, root: false
  end
end
