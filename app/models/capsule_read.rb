# == Schema Information
#
# Table name: capsule_reads
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class CapsuleRead < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :capsule
end
