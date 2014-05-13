require 'spec_helper'

describe CapsuleLocationWatch do
  describe 'watch_capsules_at_location method' do
    before do
      @user = FactoryGirl.create(:user)
      @capsule1 = FactoryGirl.create(:capsule, location: { longitude: '-96.82103', latitude: '32.96028', radius: '.02341' })
      @capsule2 = FactoryGirl.create(:capsule, location: { longitude: '-96.82917', latitude: '32.95135', radius: '.02341' })
      @capsule3 = FactoryGirl.create(:capsule, location: { longitude: '-96.82917', latitude: '32.96135', radius: '.02341' })
      @capsule4 = FactoryGirl.create(:capsule, location: { longitude: '-96.84917', latitude: '32.95135', radius: '.02341' })
      @location_watch = FactoryGirl.create(:location_watch, user: @user, latitude: 32.96179, longitude: -96.82917, radius: 0.01)
    end

    it 'creates watches for the capsules' do
      CapsuleLocationWatch.watch_capsules_at_location(@location_watch.to_param)
      expect(@user.watched_capsules.count).to eq(2)
    end
  end
end
