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
#

class Comment < ActiveRecord::Base
  include IsLikeable

  is_likeable :likes_store

  belongs_to :user, counter_cache: true, touch: true
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :replies, as: :commentable, class_name: 'Comment'   # Allows replies to the current comment
  has_many :objections, as: :objectionable, dependent: :destroy

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

end
