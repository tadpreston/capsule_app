# == Schema Information
#
# Table name: capsules
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  title             :string(255)
#  hash_tags         :string(255)
#  location          :hstore
#  status            :string(255)
#  payload_type      :string(255)
#  promotional_state :string(255)
#  visibility        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  lock_question     :string(255)
#  lock_answer       :string(255)
#  latitude          :decimal(, )
#  longitude         :decimal(, )
#

require 'spec_helper'

describe Capsule do
  before { @capsule = FactoryGirl.build(:capsule) }

  subject { @capsule }

  it { should belong_to(:user) }
  it { should have_many(:favorites) }
  it { should have_many(:favorite_users).through(:favorites) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:title) }

  describe 'before_save callback' do
    describe 'with hash_tags in the title' do
      it 'pulls hash tags out of the title and stores them in the has_tags field' do
        @capsule.save
        expect(@capsule.hash_tags).to_not be_blank
        @capsule.hash_tags.split(' ').each do |tag|
          expect(@capsule.title).to include(tag)
        end
      end
    end

    describe 'without hash tags in the title' do
      it 'hash_tags field should be blank' do
        @capsule.title = 'A title with no hash tags'
        @capsule.save
        expect(@capsule.hash_tags).to be_blank
      end
    end

    describe 'when a location is provided' do
      before do
        @capsule.latitude = nil
        @capsule.longitude = nil
      end

      it 'stores the location in the latitude and longitude fields' do
        @capsule.save
        expect(@capsule.latitude).to_not be_blank
        expect(@capsule.latitude.to_s).to eq(@capsule.location["latitude"])
        expect(@capsule.longitude).to_not be_blank
        expect(@capsule.longitude.to_s).to eq(@capsule.location["longitude"])
      end

      it 'does not store values if location is not provided' do
        @capsule.location = ''
        @capsule.save
        expect(@capsule.latitude).to be_blank
        expect(@capsule.longitude).to be_blank
      end
    end
  end

  describe 'by_updated_at scope' do
    it 'returns capsules ordered by updated_at' do
      @capsule.save
      @capsule2 = FactoryGirl.create(:capsule)
      @capsule3 = FactoryGirl.create(:capsule)
      @capsule.update_columns(updated_at: 2.days.ago)
      @capsule3.update_columns(updated_at: 1.day.ago)

      expect(Capsule.by_updated_at).to eq([@capsule2, @capsule3, @capsule])
    end
  end

  describe 'purged_title method' do
    it 'returns the title with no hash tags' do
      @capsule.title = "A title with hash tags #hashtagone #hashtagtwo"
      @capsule.save
      expect(@capsule.purged_title).to eq('A title with hash tags')
    end
  end

  describe 'find_in_rec class method' do
    before do
      @origin = { lat: 33.190, long: -96.8915 }
      @span = { lat: 40233.6, long: 40233.6 }
      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '20000' })
      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '20000' })
      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '32.989326', longitude: '-96.231873', radius: '20000' })
    end

    it 'gets the correct capsules in the rectangle' do
      expect(Capsule.find_in_rec(@origin, @span)).to eq([@capsule2, @capsule1])
    end

    it 'does not include capsules outside of the rectangle' do
      expect(Capsule.find_in_rec(@origin, @span)).to_not include(@capsule3)
    end
  end

end
