class ReceivedCapsules < CapsuleFeedBase
  attr_accessor :user

  def initialize user, offset=0, limit=500
    @user = user
    super offset, limit
  end

  private

  def capsule_scope
    user.received_capsules.includes(:user)
  end
end
