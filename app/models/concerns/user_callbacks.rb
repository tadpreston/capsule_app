class UserCallbacks
  def self.before_save(user)
    user.email.downcase!
  end
end
