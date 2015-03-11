class User::Blocker < User
  has_many :blocks, class_name: 'Block', foreign_key: :user_id
  has_many :blocked_users, through: :blocks, source: :blocked
  has_many :blockers, class_name: 'Block', foreign_key: :blocked_id
  has_many :blocked_by, through: :blockers, source: :user

  def block_user phone_number
    user = set_user phone_number
    Block.create_block id, user.id
  end

  def remove_block phone_number
    user = set_user phone_number
    Block.remove_block id, user.id
  end

  private

  def set_user phone_number
    user = User::Blocker.find_by phone_number: phone_number
    raise ActiveRecord::RecordNotFound, 'User not found by phone number' unless user
    user
  end
end
