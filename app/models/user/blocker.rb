class User::Blocker < User
  has_many :blocks, class_name: 'Block', foreign_key: :user_id
  has_many :blocked_users, through: :blocks, source: :blocked
  has_many :blockers, class_name: 'Block', foreign_key: :blocked_id
  has_many :blocked_by, through: :blockers, source: :user

  def block_user phone_number
    user = set_user phone_number
    Block.create_block id, user.id
    remove_from_feeds user.id
  end

  def remove_block phone_number
    user = set_user phone_number
    Block.remove_block id, user.id
    add_to_feed user.id
  end

  def is_blocked_by user
    blocked_by.exists? id: user.id
  end

  private

  def set_user phone_number
    user = User::Blocker.find_by phone_number: phone_number
    raise ActiveRecord::RecordNotFound, 'User not found by phone number' unless user
    user
  end

  def remove_from_feeds user_id
    Relevance.remove_feed_for id, yada_ids_from(user_id)
  end

  def yada_ids_from user_id
    relevant_yadas.where(user_id: user_id).ids
  end

  def add_to_feed user_id
    Relevance.restore_feed_for id, received_yada_ids(user_id)
  end

  def received_yada_ids user_id
    received_capsules.where(user_id: user_id).ids
  end
end
