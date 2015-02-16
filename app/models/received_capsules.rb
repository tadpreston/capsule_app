class ReceivedCapsules < CapsuleFeedBase
  attr_accessor :user

  def initialize user, offset=0, limit=500
    @user = user
    super offset, limit
  end

  private

  def capsule_scope
    Capsule.for_user(user.id).by_updated_at
  end
end
