# == Schema Information
#
# Table name: assets
#
#  id         :integer          not null, primary key
#  capsule_id :integer
#  media_type :string(255)
#  resource   :string(255)
#  metadata   :hstore
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Asset do
  before { @asset = FactoryGirl.build(:asset) }

  subject { @asset }

  it { should belong_to(:capsule) }

  it { should validate_presence_of(:media_type) }
  it { should validate_presence_of(:resource) }
end
