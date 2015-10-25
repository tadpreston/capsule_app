# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  public_id              :uuid
#  email                  :string(255)
#  username               :string(255)
#  phone_number           :string(255)
#  password_digest        :string(255)
#  location               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  authorized_at          :datetime
#  settings               :hstore
#  locale                 :string(255)
#  time_zone              :string(255)
#  oauth                  :hstore
#  created_at             :datetime
#  updated_at             :datetime
#  profile_image          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  tutorial_progress      :integer          default(0)
#  recipient_token        :string(255)
#  comments_count         :integer          default(0)
#  facebook_username      :string(255)
#  twitter_username       :string(255)
#  motto                  :string(255)
#  background_image       :string(255)
#  job_id                 :string(255)
#  complete               :boolean          default(FALSE)
#  following              :integer          default([]), is an Array
#  watching               :integer          default([]), is an Array
#  can_send_text          :boolean
#  device_token           :string(255)
#  full_name              :string(255)
#  mode                   :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  converted_at           :datetime
#

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
