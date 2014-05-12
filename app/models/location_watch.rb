# == Schema Information
#
# Table name: location_watches
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  longitude  :decimal(, )
#  latitude   :decimal(, )
#  radius     :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class LocationWatch < ActiveRecord::Base
  belongs_to :user
end
