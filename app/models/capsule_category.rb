# == Schema Information
#
# Table name: capsule_categories
#
#  id          :integer          not null, primary key
#  capsule_id  :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CapsuleCategory < ActiveRecord::Base
end
