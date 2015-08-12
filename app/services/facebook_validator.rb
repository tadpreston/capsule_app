class FacebookValidator
  def initialize facebook_user_id, token
    @facebook_user_id = facebook_user_id
    @token = token
  end

  def validates
    # return (user_exists && user_id_matches)
    return (user_id_matches)
  end

  private

  # def user_exists
  #   return User.where(facebook_username: @facebook_user_id).first != nil
  # end

  def user_id_matches
    response = FacebookGraphAPI::GET.me @token, 'id'
    return response['id'] == @facebook_user_id
  end
end
