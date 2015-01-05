# == Schema Information
#
# Table name: unlocks
#
#  id         :integer          not null, primary key
#  capsule_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Unlock < ActiveRecord::Base
  belongs_to :capsule
  belongs_to :user
end
