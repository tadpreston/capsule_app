# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :text
#  likes_store      :hstore
#  comments_count   :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#  status           :string(255)
#

class Comment < ActiveRecord::Base
  include IsLikeable

  is_likeable :likes_store

  after_create CommentCallbacks

  belongs_to :user, counter_cache: true, touch: true
  belongs_to :commentable, polymorphic: true, counter_cache: true, touch: true
  has_many :objections, as: :objectionable, dependent: :destroy

  delegate :full_name, to: :user, prefix: true
  delegate :device_token, to: :user, prefix: true
  delegate :profile_image, to: :user, prefix: true
  delegate :user_id, to: :commentable, prefix: true

  def liked_by?(user)
    if user
      likes.include?(user.id)
    else
      false
    end
  end

  def likes_count
    likes.size
  end

  def commentable_owner?
    commentable_user_id == user_id
  end

end
