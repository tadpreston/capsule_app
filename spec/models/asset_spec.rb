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

  describe 'resurce_path method' do
    before { @asset.resource = 'http://www.someurl.com/image' }

    describe 'with a full url' do
      it 'returns the unchanged url when the complete flag is true' do
        expect(@asset.resource_path).to eq('http://www.someurl.com/image')
      end
      it 'returns the unchanged url when the complete flag is false' do
        @asset.complete = false
        expect(@asset.resource_path).to eq('http://www.someurl.com/image')
      end
    end

    describe 'with processing not complete' do
      before do
        @asset.complete = false
        @asset.resource = 'filename.png'
      end

      it 'returns waiting image' do
        expect(@asset.resource_path).to eq(Asset::WAITING_PATH)
      end
    end

    describe 'with processing complete' do
      before { @asset.resource = 'filename.png' }

      it 'returns the source image with the CDN' do
        expect(@asset.resource_path).to include('filename.png')
        expect(@asset.resource_path).to include('https')
        expect(@asset.resource_path).to eq("#{Asset::CDN_HOST}/filename.png")
      end
    end
  end
end
