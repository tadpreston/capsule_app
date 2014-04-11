# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Relationship do

  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }
end
