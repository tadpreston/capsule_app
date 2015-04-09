class UserSerializer < ActiveModel::Serializer
# cached
# delegate :cache_key, to: :object

  attributes :id, :full_name, :email, :phone_number, :location, :username
  attributes :motto, :facebook_username, :twitter_username, :device_token
  attributes :locale, :time_zone, :provider, :uid, :profile_image
  attributes :background_image_path, :tutorial_progress, :settings, :email_confirmed
  attributes :watching_count, :watchers_count, :created_at, :updated_at

  def email_confirmed
    object.confirmed? ? true : false
  end

  def profile_image
    object.profile_image_path
  end
end
