class Block < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked, class_name: 'User'

  def self.create_block user_id, blocked_id
    return nil if user_blocked(user_id, blocked_id)
    create user_id: user_id, blocked_id: blocked_id
  end

  def self.remove_block user_id, blocked_id
    block = find_by user_id: user_id, blocked_id: blocked_id
    block.destroy if block
  end

  def self.user_blocked user_id, blocked_id
    find_by user_id: user_id, blocked_id: blocked_id
  end
end
