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
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :commentable, polymorphic: true, counter_cache: true
end
