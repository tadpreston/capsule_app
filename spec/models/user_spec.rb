# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  public_id       :uuid
#  email           :string(255)
#  username        :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  password_digest :string(255)
#  location        :string(255)
#  provider        :string(255)
#  uid             :string(255)
#  authorized_at   :datetime
#  locale          :string(255)
#  time_zone       :string(255)
#  settings        :hstore
#  oauth           :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  let(:oauth_attributes) do
    {
      provider: 'facebook',
      uid: '1234567',
      info: {
        nickname: 'jbloggs',
        email: 'joe@bloggs.com',
        name: 'Joe Bloggs',
        first_name: 'Joe',
        last_name: 'Bloggs',
        image: 'http://graph.facebook.com/1234567/picture?type=square',
        urls: { facebook: 'http://www.facebook.com/jbloggs' },
        location: 'Frisco, Texas',
        verified: 'true'
      },
      credentials: {
        token: 'UsMu-C1OO_ExEqKqaR47TEdAyb',
        expirec_at: 1321747205,
        expires: true
      },
      extra: {
        raw_info: {
          id: '1234567',
          name: 'Joe Bloggs',
          first_name: 'Joe',
          last_name: 'Bloggs',
          link: 'http://www.facebook.com/jbloggs',
          username: 'jbloggs',
          location: { id: '123456789', name: 'Fricso, Texas' },
          gender: 'male',
          email: 'joe@bloggs.com',
          timezone: -6,
          locale: 'en_US',
          verified: true,
          updated_time: '2011-11-11T06:21:03+0000'
        }
      }
    }
  end

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should have_many(:devices) }

  it { should be_valid }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

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

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "with oauth" do
    describe "email should not be validated" do
      before do
        oauth = oauth_attributes
        oauth[:info][:email] = ''
        @user.oauth = oauth
      end

      it { should be_valid }
    end

    describe "when uid and provider already exist" do
      before do
        FactoryGirl.create(:user, oauth: oauth_attributes)
        @user.oauth = oauth_attributes
      end
      it { should_not be_valid }
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com", password: "", password_confirmation: "")
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

  describe "return value of authenticate method with oauth" do
    before do
      @user.oauth = oauth_attributes
      @user.save
    end
    let(:found_user) { User.find_by(provider: 'facebook', uid: '1234567') }

    describe 'return value of authenticate method' do
      it { should eq found_user.authenticate }
    end
  end

  describe "find_or_create_by_oauth method" do
    it 'finds an existing user' do
      user = FactoryGirl.create(:user, oauth: oauth_attributes)
      expect(User.find_or_create_by_oauth(oauth_attributes)).to eq(user)
    end

    it 'creates a new user' do
      expect {
        User.find_or_create_by_oauth(oauth_attributes)
      }.to change(User, :count).by(1)
    end

    it 'returns the new user' do
      user = User.find_or_create_by_oauth(oauth_attributes)
      expect(user).to_not be_nil
      expect(user.provider).to eq(oauth_attributes[:provider])
      expect(user.uid).to eq(oauth_attributes[:uid])
    end
  end
end
