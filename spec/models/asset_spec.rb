# == Schema Information
#
# Table name: assets
#
#  id               :integer          not null, primary key
#  media_type       :string(255)
#  resource         :string(255)
#  metadata         :hstore
#  created_at       :datetime
#  updated_at       :datetime
#  job_id           :string(255)
#  storage_path     :string(255)
#  process_response :hstore
#  complete         :boolean          default(FALSE)
#  assetable_id     :integer
#  assetable_type   :string(255)
#

require 'spec_helper'

describe Asset do
  before { @asset = FactoryGirl.build(:asset) }

  subject { @asset }

  it { should belong_to(:assetable) }

  it { should validate_presence_of(:media_type) }
  it { should validate_presence_of(:resource) }
end
