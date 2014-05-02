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
#  visibility        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  lock_question     :string(255)
#  lock_answer       :string(255)
#  latitude          :decimal(, )
#  longitude         :decimal(, )
#  payload_type      :integer
#  promotional_state :integer
#  relative_location :hstore
#  watched           :boolean
#  incognito         :boolean
#

require 'spec_helper'

describe Capsule do
  before { @capsule = FactoryGirl.build(:capsule) }

  subject { @capsule }

  it { should belong_to(:user) }
  it { should have_many(:favorites) }
  it { should have_many(:favorite_users).through(:favorites) }
  it { should have_many(:comments) }
  it { should have_many(:assets) }
  it { should have_many(:recipient_users) }
  it { should have_many(:recipients).through(:recipient_users) }

  it { should validate_presence_of(:title) }

  it { should accept_nested_attributes_for(:comments).allow_destroy(true) }
  it { should accept_nested_attributes_for(:assets).allow_destroy(true) }

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
      @span = { lat: 2.5359475904, long: 1.7578124096 }
      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '20000' })
      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '20000' })
      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '30.089326', longitude: '-96.231873', radius: '20000' })
    end

    it 'gets the correct capsules in the rectangle' do
      expect(Capsule.find_in_rec(@origin, @span)).to eq([@capsule2, @capsule1])
    end

    it 'does not include capsules outside of the rectangle' do
      expect(Capsule.find_in_rec(@origin, @span)).to_not include(@capsule3)
    end
  end

  # TODO - Put the callback tests into another file
  describe 'after_save callback' do
    before do
      @user1 = FactoryGirl.create(:user, phone_number: '9725551212')
      @user2 = FactoryGirl.create(:user, phone_number: '2145551212')
    end

    it 'adds recipients to the capsule' do
      @capsule.recipients_attributes = [{phone_number: @user1.phone_number},{phone_number: @user2.phone_number}]
      expect {
        @capsule.save
      }.to change(RecipientUser, :count).by(2)
    end

    it 'removes recipients not listed in the recipients_attributes' do
      @capsule.recipients_attributes = [{phone_number: @user2.phone_number}]
      @capsule.save
      expect(@capsule.recipients).not_to exist(@user1)
    end

    it 'creates a user record for a new recipient' do
      @capsule.recipients_attributes = [{phone_number: '2145787422', email: 'bobdylan@gmail.com', first_name: 'Bob', last_name: 'Dylan'}]
      expect {
        @capsule.save
      }.to change(User, :count).by(1)
    end

    it 'does not create a record for an existing recipient' do
      @capsule.recipients_attributes = [{phone_number: @user1.phone_number, email: @user1.email, first_name: @user1.first_name, last_name: @user1.last_name}]
      expect {
        @capsule.save
      }.to_not change(User, :count).by(1)
    end

    it 'adds the contact to the capsule creator' do
      recipient = {phone_number: '2145787422', email: 'bobdylan@gmail.com', first_name: 'Bob', last_name: 'Dylan'}
      @capsule.recipients_attributes = [recipient]
      expect {
        @capsule.save
      }.to change(ContactUser, :count).by(1)
    end

    it 'does not add the contact to the capsule creator because it already exists' do
      recipient = {phone_number: @user1.phone_number, email: @user1.email, first_name: @user1.first_name, last_name: @user1.last_name}
      @capsule.user.contacts << @user1
      @capsule.recipients_attributes = [recipient]
      expect {
        @capsule.save
      }.to_not change(ContactUser, :count).by(1)
    end
  end

  describe "add_as_recipient method" do
    before do
      @capsule.save
      @recipient = FactoryGirl.create(:user)
    end

    it 'adds a user as a recipient' do
      @capsule.add_as_recipient(@recipient)
      expect(@capsule.recipients).to include(@recipient)
    end

    it 'does not add a recipient if it is already a recipient' do
      @capsule.recipients << @recipient
      @capsule.add_as_recipient(@recipient)
      expect(@capsule.recipients.size).to eq(1)
    end
  end

  describe "is_a_recipient? method" do
    before do
      @capsule.save
      @recipient = FactoryGirl.create(:user)
    end

    it "returns false" do
      expect(@capsule.is_a_recipient?(@recipient)).to be_false
    end

    it "returns true" do
      @capsule.recipients << @recipient
      expect(@capsule.is_a_recipient?(@recipient)).to be_true
    end
  end

  describe "is_watched? method" do
    it "returns false" do
      expect(@capsule).to_not be_watched
    end

    it "returns true" do
      @capsule.watched = true
      expect(@capsule).to be_watched
    end
  end

  describe "is_incognito? method" do
    it "returns false" do
      expect(@capsule).to_not be_incognito
    end

    it "returns true" do
      @capsule.incognito = true
      expect(@capsule).to be_incognito
    end
  end
end
