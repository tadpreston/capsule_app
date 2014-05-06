# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :capsule, counter_cache: true
end
