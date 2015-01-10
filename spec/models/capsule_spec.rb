# == Schema Information
#
# Table name: capsules
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  comment           :string(255)
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
#  incognito         :boolean
#  in_reply_to       :integer
#  comments_count    :integer          default(0)
#  likes_store       :hstore
#  is_portable       :boolean
#  thumbnail         :string(255)
#  start_date        :datetime
#  watchers          :integer          default([]), is an Array
#  readers           :integer          default([]), is an Array
#  creator           :hstore
#  likes             :integer          default([]), is an Array
#  tenant_id         :integer
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
  it { should have_many(:replies) }
  it { should belong_to(:replied_to) }
  it { should have_many(:objections) }
  it { should belong_to(:tenant) }

  it { should accept_nested_attributes_for(:comments).allow_destroy(true) }
  it { should accept_nested_attributes_for(:assets).allow_destroy(true) }
  it { should accept_nested_attributes_for(:recipients) }

  it { should delegate(:full_name).to(:user).with_prefix }

  describe 'recipients_attributes validation' do
    describe 'without any recipients' do
      it 'returns a valid capsule' do
        expect(@capsule).to be_valid
      end
    end

    describe 'with recipients' do
      it 'returns a valid capsule with a phone_number' do
        @capsule.recipients_attributes = [ { phone_number: '9728675309', full_name: 'Bob Smith' } ]
        expect(@capsule).to be_valid
      end

      it 'returns a valid capsule with a valid email' do
        @capsule.recipients_attributes = [ { email: 'test@email.com', full_name: 'Bob Smith' } ]
        expect(@capsule).to be_valid
      end

      it 'is not valid without an email and a phone number' do
        @capsule.recipients_attributes = [ { full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient key is missing'])
      end

      it 'is not valid with an invalid formatted email' do
        @capsule.recipients_attributes = [ { email: 'invalidemail', full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient email address is invalid'])
      end
    end

    describe 'with multiple recipients' do
      it 'returns a valid capsule with phone_numbers' do
        @capsule.recipients_attributes = [ { phone_number: '9728675309', full_name: 'Bob Smith' }, { phone_number: '9728675309', full_name: 'Bob Smith' } ]
        expect(@capsule).to be_valid
      end

      it 'returns a valid capsule with valid emails' do
        @capsule.recipients_attributes = [ { email: 'test@email.com', full_name: 'Bob Smith' }, { email: 'test@email.com', full_name: 'Bob Smith' } ]
        expect(@capsule).to be_valid
      end

      it 'returns a valid capsule with valid emails and phone number' do
        @capsule.recipients_attributes = [ { email: 'test@email.com', full_name: 'Bob Smith' }, { phone_number: '8178675309', full_name: 'Bob Smith' } ]
        expect(@capsule).to be_valid
      end

      it 'is not valid without an email and a phone number' do
        @capsule.recipients_attributes = [ { email: 'test@email.com', full_name: 'Bob Smith' }, { full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient key is missing'])
        @capsule.recipients_attributes = [ { full_name: 'Bob Smith' }, { phone_number: '8178675309', full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient key is missing'])
      end

      it 'is not valid with an invalid formatted email' do
        @capsule.recipients_attributes = [ { email: 'test@email.com', full_name: 'Bob Smith' }, { email: 'invalidemail', full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient email address is invalid'])
        @capsule.recipients_attributes = [ { phone_number: '9992340987', full_name: 'Bob Smith' }, { email: 'invalidemail', full_name: 'Bob Smith' } ]
        expect(@capsule).to_not be_valid
        expect(@capsule.errors.messages[:recipients_attributes]).to eq(['Recipient email address is invalid'])
      end
    end
  end

  describe 'before_save callback' do
    describe 'without hash tags in the comment' do
      it 'hash_tags field should be blank' do
        @capsule.comment = 'A comment with no hash tags'
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

  describe 'before_create callback' do
    it 'stores the creating user in the capsule' do
      @capsule.save
      expect(@capsule.creator).to_not be_blank
      expect(@capsule.creator["id"]).to eq(@capsule.user_id.to_s)
      expect(@capsule.creator["full_name"]).to eq(@capsule.user.full_name)
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

  describe '#relative_location scope' do
    before { @relative_capsules = FactoryGirl.create_list(:capsule, 3, latitude: nil, longitude: nil, location: nil, relative_location: { distance: 50, radius: 10, tutorial_level: 0 }) }

    it 'returns only capsules with a relative location' do
      absolute_capsule = FactoryGirl.create(:capsule)
      capsules = Capsule.relative_location
      expect(capsules.size).to eq(3)
      expect(capsules.to_a).to match_array(@relative_capsules)
      expect(capsules.to_a).to_not include(absolute_capsule)
    end

    it 'does not return relative capsules with an objection' do
      objected_capsule = FactoryGirl.create(:capsule, status: 'flagged')
      capsules = Capsule.relative_location
      expect(capsules.to_a).to_not include(objected_capsule)
    end
  end

  describe 'purged_comment method' do
    it 'returns the comment with no hash tags' do
      @capsule.comment = "A comment with hash tags #hashtagone #hashtagtwo"
      @capsule.save
      expect(@capsule.purged_comment).to eq('A comment with hash tags')
    end
  end

  describe 'find_in_rec scope' do
    before do
      @origin = { lat: 33.190, long: -96.8915 }
      @span = { lat: 2.5359475904, long: 1.7578124096 }
      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '20000' })
      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '20000' })
      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '30.089326', longitude: '-96.231873', radius: '20000' })
      @capsules = Capsule.find_in_rec(@origin, @span)
    end

    it 'gets the correct capsules in the rectangle' do
      expect(@capsules).to match_array([@capsule2, @capsule1])
      expect(@capsules).to_not include(@capsule3)
    end

  end

  describe 'find_from_center' do
    before do
      @origin = { lat: 33.190, long: -96.8915 }
      @span = { lat: 1.25, long: 0.875 }
      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.163793', radius: '20000' })
      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '34.013300', longitude: '-97.623046', radius: '20000' })
      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '30.089326', longitude: '-96.231873', radius: '20000' })
      @capsules = Capsule.find_from_center(@origin, @span)
    end

    it 'gets the correct capsules in the rectangle' do
      expect(@capsules).to match_array([@capsule2, @capsule1])
      expect(@capsules).to_not include(@capsule3)
    end
  end

#  describe 'with_hash_tag scope' do
#    it 'returns capsules with the right tags' do
#      capsule1 = FactoryGirl.create(:capsule, comment: 'comment with #tag1 #tag2')
#      capsule2 = FactoryGirl.create(:capsule, comment: 'comment with #tag3 tag#4')
#      capsule3 = FactoryGirl.create(:capsule, comment: 'comment with #tag1 #tag4')
#      capsules = Capsule.with_hash_tag('#tag1')
#      expect(capsules.size).to eq(2)
#      expect(capsules).to match_array([capsule1, capsule3])
#      expect(capsules).to_not include(capsule2)
#    end
#  end

#  describe 'find_location_hash_tags method' do
#    before do
#      @origin = { lat: 33.190, long: -96.8915 }
#      @span = { lat: 2.5359475904, long: 1.7578124096 }
#      @capsule1 = FactoryGirl.create(:capsule, comment: 'comment with #tag1 #tag2', location: { latitude: '33.167111', longitude: '-96.663793', radius: '20000' })
#      @capsule2 = FactoryGirl.create(:capsule, comment: 'comment with #tag3 #tag4', location: { latitude: '33.013300', longitude: '-96.823046', radius: '20000' })
#      @capsule3 = FactoryGirl.create(:capsule, comment: 'comment with #tag1 #tag2', location: { latitude: '30.089326', longitude: '-96.231873', radius: '20000' })
#    end
#
#    it 'gets the correct capsules without a hashtag' do
#      capsules = Capsule.find_location_hash_tags(@origin, @span)
#      expect(capsules.size).to eq(2)
#      expect(capsules).to match_array([@capsule1, @capsule2])
#      expect(capsules).to_not include(@capsule3)
#    end
#
#    it 'gets the correct capsules with a hashtag' do
#      capsules = Capsule.find_location_hash_tags(@origin, @span, '#tag2')
#      expect(capsules.size).to eq(1)
#      expect(capsules.to_a).to eq([@capsule1])
#      expect(capsules.to_a).to_not include(@capsule2)
#      expect(capsules.to_a).to_not include(@capsule3)
#    end
#  end

  describe 'hidden scope' do
    it 'finds the hidden capsules' do
      capsule1 = FactoryGirl.create(:capsule, incognito: true)
      capsule2 = FactoryGirl.create(:capsule)

      capsules = Capsule.hidden
      expect(capsules.count).to eq(1)
      expect(capsules[0]).to eq(capsule1)
    end
  end

  describe 'not_hidden scope' do
    it 'finds capsules that are not hidden' do
      capsule1 = FactoryGirl.create(:capsule, incognito: true)
      capsule2 = FactoryGirl.create(:capsule, incognito: false)

      capsules = Capsule.not_hidden
      expect(capsules.count).to eq(1)
      expect(capsules[0]).to eq(capsule2)
    end
  end

  describe 'absolute_location scope' do
    it 'finds capsules that have an absolute location' do
      capsule1 = FactoryGirl.create(:capsule)
      capsule2 = FactoryGirl.create(:capsule, relative_location: { location: { latitude: 33, longitude: -96 } })

      capsules = Capsule.absolute_location
      expect(capsules.count).to eq(1)
      expect(capsules).to eq([capsule1])
    end
  end

  describe 'public_capsules scope' do
    it 'finds all capsules that are public' do
      capsule1 = FactoryGirl.create(:capsule)
      capsule2 = FactoryGirl.create(:capsule)
      capsule3 = FactoryGirl.create(:capsule)
      capsule2.recipients << FactoryGirl.create(:user)

      capsules = Capsule.public_capsules
      expect(capsules.count).to eq(2)
      expect(capsules).to match_array([capsule1, capsule3])
      expect(capsules).to_not include(capsule2)
    end
  end

  describe 'public_with_user scope' do
    it 'finds all capsules that are public and and the user is a recipient' do
      capsule1 = FactoryGirl.create(:capsule)
      capsule2 = FactoryGirl.create(:capsule)
      capsule3 = FactoryGirl.create(:capsule)
      capsule4 = FactoryGirl.create(:capsule)
      capsule2.recipients << FactoryGirl.create(:user)
      user = FactoryGirl.create(:user)
      capsule4.recipients << user

      capsules = Capsule.public_with_user(user.id)
      expect(capsules.count).to eq(3)
      expect(capsules).to match_array([capsule1,capsule3,capsule4])
      expect(capsules).to_not include(capsule2)
    end
  end

  describe 'without_objections scope' do
    it 'returns only capsules without an objection' do
      capsule1 = FactoryGirl.create(:capsule)
      capsule2 = FactoryGirl.create(:capsule, status: 'objection')
      capsule3 = FactoryGirl.create(:capsule)

      capsules = Capsule.without_objections

      expect(capsules).to_not include(capsule2)
      expect(capsules).to match_array([capsule1, capsule3])
    end
  end

  describe 'search_capsules method' do
    it 'returns capsules that match the search term' do
      capsule1 = FactoryGirl.create(:capsule, comment: 'This is a test capsule')
      capsule2 = FactoryGirl.create(:capsule, comment: 'Just an average capsule')
      capsule3 = FactoryGirl.create(:capsule, comment: 'Another test capsule')

      capsules = Capsule.search_capsules('test')
      expect(capsules.size).to eq(2)
      expect(capsules).to include(capsule1)
      expect(capsules).to include(capsule3)
    end

    it 'returns capsules that match the search term and are not hidden' do
      capsule1 = FactoryGirl.create(:capsule, comment: 'This is a test capsule', incognito: true)
      capsule2 = FactoryGirl.create(:capsule, comment: 'Just an average capsule')
      capsule3 = FactoryGirl.create(:capsule, comment: 'Another test capsule')

      capsules = Capsule.search_capsules('test')
      expect(capsules.size).to eq(1)
      expect(capsules).to include(capsule3)
    end

    it 'returns capsules that match the search term and are absolute position' do
      capsule1 = FactoryGirl.create(:capsule, comment: 'This is a test capsule')
      capsule2 = FactoryGirl.create(:capsule, comment: 'Just an average capsule')
      capsule3 = FactoryGirl.create(:capsule, comment: 'Another test capsule', relative_location: { location: { latitude: 33, longitude: -97 } })

      capsules = Capsule.search_capsules('test')
      expect(capsules.size).to eq(1)
      expect(capsules).to include(capsule1)
    end

    it 'returns capsules that match the search term and are public' do
      capsule1 = FactoryGirl.create(:capsule, comment: 'This is a test capsule')
      capsule2 = FactoryGirl.create(:capsule, comment: 'Just an average capsule')
      capsule3 = FactoryGirl.create(:capsule, comment: 'Another test capsule')
      capsule1.recipients << FactoryGirl.create(:user)

      capsules = Capsule.search_capsules('test')
      expect(capsules.size).to eq(1)
      expect(capsules).to include(capsule3)
    end

    it 'returns capsules that match the search term and the user is a recipient' do
      capsule1 = FactoryGirl.create(:capsule, comment: 'This is a test capsule')
      capsule2 = FactoryGirl.create(:capsule, comment: 'Just an average capsule')
      capsule3 = FactoryGirl.create(:capsule, comment: 'Another test capsule')
      capsule4 = FactoryGirl.create(:capsule, comment: 'Some testing going on')
      user = FactoryGirl.create(:user)
      capsule1.recipients << user
      capsule4.recipients << FactoryGirl.create(:user)

      capsules = Capsule.search_capsules('test', user)
      expect(capsules.size).to eq(2)
      expect(capsules).to include(capsule1)
      expect(capsules).to include(capsule3)
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
      @capsule.recipients_attributes = [{phone_number: '2145787422', email: 'bobdylan@gmail.com', full_name: 'Bob Dylan'}]
      expect {
        @capsule.save
      }.to change(User, :count).by(1)
    end

    it 'does not create a record for an existing recipient' do
      @capsule.recipients_attributes = [{phone_number: @user1.phone_number, email: @user1.email, full_name: @user1.full_name}]
      expect {
        @capsule.save
      }.to_not change(User, :count).by(1)
    end

    it 'adds the contact to the capsule creator' do
      recipient = {phone_number: '2145787422', email: 'bobdylan@gmail.com', full_name: 'Bob Dylan'}
      @capsule.recipients_attributes = [recipient]
      expect {
        @capsule.save
      }.to change(ContactUser, :count).by(1)
    end

    it 'does not add the contact to the capsule creator because it already exists' do
      recipient = {phone_number: @user1.phone_number, email: @user1.email, full_name: @user1.full_name}
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

  describe "is_incognito? method" do
    it "returns false" do
      expect(@capsule).to_not be_incognito
    end

    it "returns true" do
      @capsule.incognito = true
      expect(@capsule).to be_incognito
    end
  end

  describe "read_by? method" do
    before do
      @capsule.save
      @user = FactoryGirl.create(:user)
    end

    it "returns false" do
      expect(@capsule.read_by?(@user)).to be_false
    end

    it "returns true" do
      @capsule.read @user
      expect(@capsule.read_by?(@user)).to be_true
    end

    it "returns false if user is nil" do
      expect(@capsule.read_by?(nil)).to be_false
    end
  end

  describe 'association caching methods' do
    it { should respond_to(:cached_user) }
    it { should respond_to(:cached_recipients) }
    it { should respond_to(:cached_assets) }
    it { should respond_to(:cached_comments) }
    it { should respond_to(:cached_read_by) }
    it { should respond_to(:cached_watchers) }
  end

#  describe 'search_hashtags class method' do
#    before do
#      @capsule1 = FactoryGirl.create(:capsule, comment: 'A comment #withhashtags #testing #wowfun')
#      @capsule2 = FactoryGirl.create(:capsule, comment: 'Another #stuckintheoffice #withhashtags comment #niceday')
#      @capsule3 = FactoryGirl.create(:capsule, comment: 'Interesting #shouldnotfind #intheresults')
#    end
#
#    it 'returns the correct capsules' do
#      capsules = Capsule.search_hashtags('#withhashtags')
#      expect(capsules.to_a.size).to eq(2)
#      expect(capsules).to match_array([@capsule1, @capsule2])
#    end
#
#    it 'returns a partial match' do
#      capsules = Capsule.search_hashtags('#intheresu')
#      expect(capsules.to_a.size).to eq(1)
#      expect(capsules).to eq([@capsule3])
#    end
#
#    it 'returns the matching hashtag' do
#      capsules = Capsule.search_hashtags('#withhashtags')
#      capsules.each { |c| expect(c.hash_tags).to eq(['#withhashtags']) }
#    end
#
#    it 'returns the matching hashtag with a partial match' do
#      capsules = Capsule.search_hashtags('#withhas')
#      capsules.each { |c| expect(c.hash_tags).to eq(['#withhashtags']) }
#    end
#  end

end
