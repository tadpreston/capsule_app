# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  public_id            :uuid
#  email                :string(255)
#  username             :string(255)
#  phone_number         :string(255)
#  password_digest      :string(255)
#  location             :string(255)
#  provider             :string(255)
#  uid                  :string(255)
#  authorized_at        :datetime
#  settings             :hstore
#  locale               :string(255)
#  time_zone            :string(255)
#  oauth                :hstore
#  created_at           :datetime
#  updated_at           :datetime
#  profile_image        :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  unconfirmed_email    :string(255)
#  tutorial_progress    :integer          default(0)
#  recipient_token      :string(255)
#  comments_count       :integer          default(0)
#  facebook_username    :string(255)
#  twitter_username     :string(255)
#  motto                :string(255)
#  background_image     :string(255)
#  job_id               :string(255)
#  complete             :boolean          default(FALSE)
#  following            :integer          default([]), is an Array
#  watching             :integer          default([]), is an Array
#  can_send_text        :boolean
#  device_token         :string(255)
#  full_name            :string(255)
#  mode                 :string(255)
#

require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  let(:oauth_attributes) do
    {
      location: {
        id: '113407485335936',
        name: 'Frisco, Texas'
      },
      timezone: -5,
      updated_time: '2014-03-02T16:01:04+0000',
      name: 'Joe Bloggs',
      email: 'joe@bloggs.com',
      birthday: '06\/14\/1978',
      locale: 'en_US',
      first_name: 'Joe',
      username: 'jbloggs',
      id: '1234567',
      provider: 'facebook',
      uid: '1234567',
      gender: 'male',
      last_name: 'Bloggs',
      hometown: {
        id: '987654321',
        name: 'Frisco, Texas'
      },
      link: 'https:\/\/www.facebook.com\/steelyb'
    }
  end
  let(:twitter_oauth) do
    {
        uid: 18554325,
        id: 18554325,
        lang: "en",
        email: 'joe@bloggs.com',
        geo_enabled: false,
        time_zone: "Mountain Time (US & Canada)",
        profile_image_url: "http:\/\/pbs.twimg.com\/profile_images\/69339932\/P1000115_normal.jpg",
        location: "Denton, TX",
        name: "Burton Lee",
        provider: "twitter",
        screen_name: "Bokojo",
    }
  end
  let(:google_oauth) do
    {
      id: "1819526800765",
      displayName: "Hank Williams",
      circledByCount: 0,
      uid: "1819526800765",
      isPlusUser: true,
      etag: "\"TTbz3xy1I5OVJNV4ylIvI-QbXF4\/666AlFaurvQoOoZoAXBUayCKUms\"",
      image: { url: "https:\/\/lh4.googleusercontent.com\/-fH8zP14_9Ps\/AAAAAAAAAAI\/AAAAAAAAABk\/-r4buFIy4As\/photo.jpg?sz=50" },
      language: "en",
      url: "https:\/\/plus.google.com\/113526695819526800765",
      provider: "google",
      emails: [
        { value: "hankwilliams@google.com", type: "account" }
      ],
      name: { familyName: "Williams", givenName: "Hank" },
      domain: "capsuleapp.com"
    }
  end

  subject { @user }

  it { should respond_to(:full_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should have_many(:devices) }
  it { should have_many(:capsules) }
  it { should have_many(:favorites) }
  it { should have_many(:favorite_capsules).through(:favorites) }
  it { should have_many(:comments) }
  it { should have_many(:recipient_users) }
  it { should have_many(:received_capsules).through(:recipient_users) }
  it { should have_many(:contact_users) }
  it { should have_many(:contacts).through(:contact_users) }
  it { should have_many(:reads) }
  it { should have_many(:read_capsules).through(:reads) }
  it { should have_many(:location_watches) }

  # Validations
  it { should be_valid }

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "with oauth" do
    describe "email should not be validated" do
      before do
        oauth = oauth_attributes
        oauth[:email] = ''
        @user.oauth = oauth
      end

#     it { should be_valid }
    end

    describe "when uid and provider already exist" do
      before do
        FactoryGirl.create(:user, oauth: oauth_attributes)
        @user.oauth = oauth_attributes
      end
      it { should_not be_valid }
    end
  end

  describe "with twitter oauth" do
    describe "email should not be validated" do
      before do
        oauth = twitter_oauth
        @user.oauth = oauth
      end

      it { should be_valid }
    end

    describe "when uid and provider already exist" do
      before do
        FactoryGirl.create(:user, oauth: twitter_oauth)
        @user.oauth = twitter_oauth
      end
      it { should_not be_valid }
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(full_name: "Example User", email: "user@example.com", password: "", password_confirmation: "")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "#generate_token(column)" do
    it 'generates a unique token for a given column' do
      expect(User.generate_token(:recipient_token)).to_not be_blank
    end
  end

  describe ".authenticate(password)" do
    let(:password) { 'supersecret' }
    let(:user) { FactoryGirl.create(:user, email: 'test@testing.com', password: password, password_confirmation: password) }

    it 'returns the current user' do
      expect(user.authenticate(password)).to eq(user)
    end
  end

  describe ".current_device" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:device) { FactoryGirl.create(:device, user: user) }

    it 'returns the current_device for the user' do
      expect(user.current_device).to eq(device)
    end
  end

  describe 'user following' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:user) }

    describe ".follow!(other_user)" do

      context 'other_user is not a follower' do
        it 'adds the other_user to the follower list' do
          user.follow!(other_user)
          expect(user.following).to include(other_user.id)
        end
      end

      context 'other_user is a follower' do
        it 'does not add other_user' do
          user.follow!(other_user)
          user.follow!(other_user)
          expect(user.following.size).to eq(1)
          expect(user.following).to match_array([other_user.id])
        end
      end
    end

    describe ".following?(other_user)" do
      before { user.follow!(other_user) }

      subject { user }

      it { should be_following(other_user) }
      it { should_not be_following(FactoryGirl.create(:user)) }
    end

    describe ".unfollow!(other_user)" do
      before { user.follow!(other_user) }

      it 'removes a followed user' do
        user.unfollow!(other_user)
        expect(user.following).to_not include(other_user.id)
      end
    end

    describe '.followed_users' do
      let!(:other_users) { FactoryGirl.create_list(:user, 3) }
      before { other_users.each { |u| user.follow!(u) } }

      it 'returns the followed users' do
        expect(user.followed_users).to match_array(other_users)
      end
    end

    describe '.followers' do
      let!(:other_users) { FactoryGirl.create_list(:user, 3) }
      before { other_users.each { |u| u.follow!(user) } }

      it 'returns user that are following the user' do
        expect(user.followers).to match_array(other_users)
      end
    end

    describe '.watching_count' do
      let!(:other_users) { FactoryGirl.create_list(:user, 3) }
      before { other_users.each { |u| user.follow!(u) } }
      subject { user }
      its(:watching_count) { should eq(3) }
    end

    describe '.watchers_count' do
      let!(:other_users) { FactoryGirl.create_list(:user, 3) }
      before { other_users.each { |u| u.follow!(user) } }
      subject { user }
      its(:watchers_count) { should eq(3) }
    end

  end

  describe 'contacts' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:contact) { FactoryGirl.create(:user) }

    describe ".add_as_contact(contact)" do
      context 'contact does not exist' do
        it 'adds as a contact' do
          user.add_as_contact(contact)
          expect(user.contacts).to include(contact)
        end
      end

      context "contact already exists" do
        it "does not add as contact again" do
          user.contacts << contact
          user.add_as_contact(contact)
          expect(user.contacts.size).to eq(1)
        end
      end
    end

    describe ".is_a_contact?" do
      it "returns false" do
        expect(user.is_a_contact?(contact)).to be_false
      end

      it "returns true" do
        user.contacts << contact
        expect(user.is_a_contact?(contact)).to be_true
      end
    end
  end

  describe "send_confirmation_email method" do
    before { @user.save }

    it "generates a confirmation token" do
      UserMailer.stub(:email_confirmation).and_return(double("Mailer", deliver: true))
      @user.send_confirmation_email
      expect(@user.confirmation_token).to_not be_nil
      expect(@user.confirmation_sent_at).to_not be_nil
    end

    it "sends an email" do
#      UserMailer.should_receive(:email_confirmation).and_return(double("Mailer", deliver: true))
#      @user.send_confirmation_email
    end
  end

  describe ".email_confirmed!" do
    let(:user) { FactoryGirl.create(:user, unconfirmed_email: 'unconfirmed@gmail.com') }
    before { user.email_confirmed! }

    it 'sets the confirmed_at date' do
      expect(user.confirmed_at).to_not be_nil
    end

    it 'moves the unconfirmed_email to the email' do
      expect(user.email).to eq('unconfirmed@gmail.com')
      expect(user.unconfirmed_email).to be_nil
    end
  end

  describe ".confirmed?" do
    before { @user.save }

    it "is not confirmed" do
      expect(@user).to_not be_confirmed
    end

    it "is confirmed" do
      @user.confirmed_at = Time.now
      expect(@user).to be_confirmed
    end
  end

  describe "email_confirmed method" do
    before { @user.save }

    it "sets the confirmed_at date" do
      @user.email_confirmed!
      expect(@user).to be_confirmed
    end

    it "sets the email to the unconfirmed_email" do
      @user.update_columns(unconfirmed_email: 'anewemail@test.com')
      @user.email_confirmed!
      expect(@user.email).to eq('anewemail@test.com')
    end
  end

end
