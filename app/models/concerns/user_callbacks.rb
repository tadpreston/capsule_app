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
#     user.location = eval(user.oauth["location"])[
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
      user.time_zone = user.oauth["timezone"]
      user.locale = user.oauth["locale"]

#      info = eval(user.oauth["info"]).with_indifferent_access
#      extra = eval(user.oauth["extra"]).with_indifferent_access
#      raw_info = extra["raw_info"].with_indifferent_access
#      user.email = info["email"] if info["email"]
#      user.username = info["nickname"]
#      user.first_name = info["first_name"]
#      user.last_name = info["last_name"]
#      user.location = info["location"]
#      user.time_zone = raw_info["timezone"] if raw_info["timezone"]
    else
      user.provider = "capsule"
    end
  end
end
