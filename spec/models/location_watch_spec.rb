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

require 'spec_helper'

describe LocationWatch do
  it { should belong_to(:user) }
end
