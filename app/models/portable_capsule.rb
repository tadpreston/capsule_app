# == Schema Information
#
# Table name: portable_capsules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class PortableCapsule < ActiveRecord::Base
  belongs_to :user
  belongs_to :capsule
end
