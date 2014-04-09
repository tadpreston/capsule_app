class UserCallbacks
  def self.before_save(user)
    user.email.downcase! if user.email
  end

  def self.before_validation(user)
    if user.oauth
      user.provider = user.oauth["provider"]
      user.uid = user.oauth["uid"]
      user.email = user.oauth["email"]
      user.username = user.oauth["username"]
      user.first_name = user.oauth["first_name"]
      user.last_name = user.oauth["last_name"]
      user.location = eval(user.oauth["location"])["name"]
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
      user.time_zone = user.oauth["timezone"]
      user.locale = user.oauth["locale"]
    else
      user.provider = "capsule"
    end
  end
end
