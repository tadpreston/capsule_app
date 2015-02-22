class Feed < CapsuleFeedBase
  attr_accessor :user_id

  def initialize user_id, offset=0, limit=500
    @user_id = user_id
    super offset, limit
  end

  private

  def capsule_scope
    user.relevant_yadas.order('relevances.relevant_date DESC')
  end

  def user
    @user ||= User.find user_id
  end
end
