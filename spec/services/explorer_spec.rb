require 'spec_helper'

describe Explorer do

  let(:origin) { { lat: 33.3293861080266, long: -97.3614205258122 } }
  let(:span) { { lat: 1.150484016641127, long: 1.114457652929457 } }

  it 'should initialize' do
    expect(Explorer.new(origin, span)).to be_an(Explorer)
    expect(Explorer.new(origin, span, '#hashtag')).to be_an(Explorer)
  end

  describe '#find_capsules' do
    before do
      tenant = FactoryGirl.create(:tenant)
      FactoryGirl.create(:capsule, location: { latitude: 32.190242286789, longitude: -96.729577804588985 }, tenant_id: tenant.id)
      FactoryGirl.create(:capsule, location: { latitude: 32.190382287689, longitude: -96.722517003598985 }, tenant_id: tenant.id)
      Tenant.current_id = tenant.id
    end

    it 'returns capsule boxes in a hash' do
      capsules = Explorer.new(origin, span).find_capsules
      expect(capsules).to be_a(Hash)
      expect(capsules[:capsules]).to be_an(Array)
      expect(capsules[:boxes]).to be_an(Array)
      expect(capsules[:capsules]).to be_empty
      expect(capsules[:boxes].size).to eq(1)
      expect(capsules[:boxes][0][:count]).to eq(2)
    end

    it 'returns individual capsules and boxes' do
      FactoryGirl.create(:capsule, location: { latitude: 33.142479148926315, longitude: -97.12089446210019 })
      capsules = Explorer.new(origin, span).find_capsules
      expect(capsules[:capsules].size).to eq(1)
      expect(capsules[:boxes].size).to eq(1)
    end
  end
end
