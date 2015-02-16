class Feed < CapsuleFeedBase
  attr_accessor :user_id

  def initialize user_id, offset=0, limit=500
    @user_id = user_id
    super offset, limit
  end

  private

  def capsule_scope
    Capsule.feed(user_id).by_updated_at
  end
end
