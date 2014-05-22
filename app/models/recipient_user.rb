# == Schema Information
#
# Table name: recipient_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class RecipientUser < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :capsule, touch: true
end
