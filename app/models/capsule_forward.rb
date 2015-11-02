# == Schema Information
#
# Table name: capsule_forwards
#
#  id         :integer          not null, primary key
#  capsule_id :integer
#  forward_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class CapsuleForward < ActiveRecord::Base
  belongs_to :capsule
  belongs_to :forward, class_name: 'Capsule', foreign_key: 'forward_id'
end
