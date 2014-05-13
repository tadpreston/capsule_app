require 'spec_helper'

describe CapsuleLocationWatch do
  before do
    @user = FactoryGirl.create(:user)
    @capsule1 = FactoryGirl.create(:capsule, location: { longitude: '-96.82103', latitude: '32.96028', radius: '.02341' })
    @capsule2 = FactoryGirl.create(:capsule, location: { longitude: '-96.82917', latitude: '32.95135', radius: '.02341' })
    @capsule3 = FactoryGirl.create(:capsule, location: { longitude: '-96.82917', latitude: '32.96135', radius: '.02341' })
    @capsule4 = FactoryGirl.create(:capsule, location: { longitude: '-96.84917', latitude: '32.95135', radius: '.02341' })
    @location_watch = FactoryGirl.create(:location_watch, user: @user, latitude: 32.96179, longitude: -96.82917, radius: 0.01)
  end

  describe 'watch_capsules_at_location method' do
    it 'creates watches for the capsules' do
      CapsuleLocationWatch.watch_capsules_at_location(@location_watch.to_param)
      expect(@user.watched_capsules.count).to eq(2)
    end
  end

  describe 'unwatch_capsules_at_location method' do
    before do
      @user.watch_capsule(@capsule1)
      @user.watch_capsule(@capsule3)
      location = { 'lat' => @location_watch.latitude.to_f, 'long' => @location_watch.longitude.to_f, 'radius' => @location_watch.radius.to_f }
      CapsuleLocationWatch.unwatch_capsules_at_location(location, @user.id)
    end

    it 'removes the watch from the user' do
      expect(@user.watched_capsules.count).to eq(0)
    end

    it 'does not delete the capsule' do
      expect(Capsule.count).to eq(4)
    end
  end

  describe 'add_to_watched_locations method' do
    it 'adds a watch to the the location watchers' do
      new_capsule = FactoryGirl.create(:capsule, location: { longitude: '-96.83103', latitude: '32.97028', radius: '.02341' })
      expect {
        CapsuleLocationWatch.add_to_watched_locations(new_capsule.id)
      }.to change(CapsuleWatch, :count).by(1)
    end
  end
end
