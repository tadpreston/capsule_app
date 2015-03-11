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

  private

  def set_user phone_number
    user = User::Blocker.find_by phone_number: phone_number
    raise ActiveRecord::RecordNotFound, 'User not found by phone number' unless user
    user
  end

  def remove_from_feeds user_id
    relevances = Relevance.where capsule_id: yada_ids_from(user_id), user_id: id
    relevances.destroy_all
  end

  def yada_ids_from user_id
    relevant_yadas.where(user_id: user_id).ids
  end

  def add_to_feed user_id
    capsule_ids = received_capsules.where(user_id: user_id).ids
    capsule_ids.each { |capsule_id| Relevance.create capsule_id: capsule_id, user_id: id, relevant_date: DateTime.now }
  end
end
