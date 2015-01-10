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
  it { should belong_to(:assetable) }

  it { should validate_presence_of(:media_type) }
  it { should validate_presence_of(:resource) }

  def create_asset(*traits)
    attrs = traits.extract_options!
    traits.push({}.merge(attrs))
    FactoryGirl.create(:asset, *traits)
  end

  describe '#resurce_path' do

    context 'with a full url' do
      let(:asset) { create_asset(resource: 'http://www.someurl.com/image') }

      it 'returns the unchanged url when the complete flag is true' do
        expect(asset.resource_path).to eq('http://www.someurl.com/image')
      end
      it 'returns the unchanged url when the complete flag is false' do
        asset.complete = false
        expect(asset.resource_path).to eq('http://www.someurl.com/image')
      end
    end
  end
end
