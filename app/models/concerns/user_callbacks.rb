class UserCallbacks
  def self.before_save(user)
    create_oauth(user) if user.oauth_changed?
    create_password(user) if user.password_digest.blank?
    user.email.downcase! if user.email_changed?
  end

  def self.before_validation(user)
    create_oauth(user) if user.oauth
  end

  def self.after_create(user)
    user.send_confirmation_email unless user.is_recipient?
  end

  def self.after_save user
    user.send_confirmation_email if user.provider_changed?
  end

  private

  def self.process_image user, asset_type
    create_asset(user, asset_type) if process_the_image?(user, asset_type)
  end

  def self.process_the_image? user, asset_type
    !user.send("#{asset_type}_image".to_sym).include? '/'
  end

  def self.create_asset user, asset_type
    asset = user.send "#{asset_type}_asset"
    asset.destroy if asset
    user.assets.create(resource: user.send("#{asset_type}_image".to_sym), media_type: asset_type)
  end

  def self.create_oauth(user)
    user.uid = user.oauth["uid"]
    oauth_hash = OauthHash.new(user.oauth).to_json
    ['provider', 'email', 'username', "full_name", 'location', 'locale', 'profile_image'].each do |column|
      user.send("#{column}=", oauth_hash[column])
    end
    create_password user
  end

  def self.create_password user
    tmp_pwd = SecureRandom.hex
    user.password = tmp_pwd
    user.password_confirmation = tmp_pwd
  end
end
