# == Schema Information
#
# Table name: contact_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ContactUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, class_name: 'User'
end
