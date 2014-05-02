class UserCallbacks
  def self.before_save(user)
    create_oauth(user) if user.oauth
    user.email.downcase! if user.email
  end

  def self.before_validation(user)
    create_oauth(user) if user.oauth
  end

  def self.after_commit(user)
    FriendsWorker.perform_async(user.id)
  end

  def self.after_create(user)
    user.send_confirmation_email
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
