class UserCallbacks
  def self.before_save(user)
    create_oauth(user) if user.oauth_changed?
    user.email.downcase! if user.email_changed?
  end

  def self.after_save(user)
    if user.profile_image_changed?
      unless user.profile_image.include?('/')
        if asset = user.profile_asset
          asset.destroy
        end
        user.assets.create(resource: user.profile_image, media_type: 'profile')
      end
    end
    if user.background_image_changed?
      unless user.background_image.include?('/')
        if asset = user.background_asset
          asset.destroy
        end
        user.assets.create(resource: user.background_image, media_type: 'background')
      end
    end
  end

  def self.before_validation(user)
    create_oauth(user) if user.oauth
  end

  def self.after_commit(user)
  end

  def self.after_create(user)
#   user.send_confirmation_email
    FriendsWorker.perform_in(5.seconds, user.id)
  end

  private

    def self.create_oauth(user)
      oauth_hash = OauthHash.new(user.oauth).to_json

      user.provider = oauth_hash["provider"]
      user.uid = user.oauth["uid"]
      user.email = oauth_hash["email"]
      user.username = oauth_hash["username"]
      user.first_name = oauth_hash["first_name"]
      user.last_name = oauth_hash["last_name"]
      user.location = oauth_hash["location"]
      user.time_zone = oauth_hash["timezone"]
      user.locale = oauth_hash["locale"]
      user.profile_image = oauth_hash["profile_image"]
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
    end

end
