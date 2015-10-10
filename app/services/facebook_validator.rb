class FacebookValidator
  def self.validate_user facebook_user_id, token
    new(facebook_user_id, token).validate_user
  end

  def initialize facebook_user_id, token
    @facebook_user_id = facebook_user_id
    @token = token
  end

  def validate_user
    # return (user_exists && user_id_matches)
    user_id_matches?
  end

  private

  # def user_exists
  #   return User.where(facebook_username: @facebook_user_id).first != nil
  # end

  def user_id_matches?
    response = FacebookGraphAPI::GET.me @token, 'id'
    response['id'] == @facebook_user_id
  end
end
