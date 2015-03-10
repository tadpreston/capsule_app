class UserBlock < User
  has_many :blocks, class_name: 'Block', foreign_key: :user_id
  has_many :blocked_users, through: :blocks, source: :blocked
  has_many :blockers, class_name: 'Block', foreign_key: :blocked_id
  has_many :blocked_by, through: :blockers, source: :user
end
