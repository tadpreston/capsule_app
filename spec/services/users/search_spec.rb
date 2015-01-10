require 'spec_helper'

describe Users::Search do

  describe "#find_or_create_by_phone_number(phone_number, user_attributes)" do
    it "finds an existing user" do
      FactoryGirl.create(:user, phone_number: '2145551212')
      user = Users::Search.find_or_create_by_phone_number('2145551212')
      expect(user).to_not be_nil
      expect(user).to be_a(User)
    end

    it "creates a user if not found" do
      expect {
        Users::Search.find_or_create_by_phone_number('2145551212', {email: 'bobdylan@gmail.com', full_name: 'Bob Dylan'})
      }.to change(User, :count).by(1)
    end

    it "persists a user object" do
      user = Users::Search.find_or_create_by_phone_number('2145551212', {email: 'bobdylan@gmail.com', full_name: 'Bob Dylan'})
      expect(user).to be_persisted
      expect(user).to be_a(User)
    end
  end

  describe "#find_or_create_recipient(attributes)" do
    context "contact does not exist" do
      it "creates a user" do
        expect {
          Users::Search.find_or_create_recipient({email: 'testing@email.com'})
        }.to change(User, :count).by(1)
        expect {
          Users::Search.find_or_create_recipient({phone_number: '9725551212'})
        }.to change(User, :count).by(1)
      end

      it "persists the user" do
        contact = Users::Search.find_or_create_recipient({email: 'testing@email.com'})
        expect(contact).to be_persisted
        expect(contact).to be_a(User)
        contact = Users::Search.find_or_create_recipient({phone_number: '9725551212'})
        expect(contact).to be_persisted
        expect(contact).to be_a(User)
      end

      it "creates a recipient_token" do
        contact = Users::Search.find_or_create_recipient({phone_number: '9725551212'})
        expect(contact.recipient_token).to_not be_blank
      end

      it "creates a user with various values" do
        contact = Users::Search.find_or_create_recipient({phone_number: '9725551212', email: 'testing@email.com', full_name: 'tester person'})
        expect(contact.email).to eq('testing@email.com')
        expect(contact.full_name).to eq('tester person')
        expect(contact.phone_number).to eq('9725551212')
      end
    end

    context "contact does exist" do
      it "finds an existing user" do
        user = FactoryGirl.create(:user)
        expect(Users::Search.find_or_create_recipient({email: user.email})).to eq(user)
      end
    end
  end

  describe "#by_identity(query)" do
    let(:user_with_username) { FactoryGirl.create(:user, username: 'testperson') }
    let(:user_with_email) { FactoryGirl.create(:user, email: 'testing@email.com') }

    context 'searching with a username' do
      it 'returns user with the username' do
        expect(Users::Search.by_identity('@testperson')).to eq([user_with_username])
        expect(Users::Search.by_identity('something @testperson')).to eq([user_with_username])
        expect(Users::Search.by_identity('something @testperson after')).to eq([user_with_username])
      end
    end

    context 'searching with an email address' do
      it 'returns user with an email' do
        expect(Users::Search.by_identity('testing@email.com')).to eq([user_with_email])
      end
    end
  end

  describe "#search_by_name(query)" do
    let!(:user_william) { FactoryGirl.create(:user, full_name: 'William Johnson') }
    let!(:user_john) { FactoryGirl.create(:user, full_name: 'John Wilson') }
    let!(:user_mary) { FactoryGirl.create(:user, full_name: 'Mary Jones') }

    context 'with one param' do
      it 'returns the matches' do
        expect(Users::Search.by_name('Wil').to_a).to match_array([user_william, user_john])
        expect(Users::Search.by_name('wil').to_a).to match_array([user_william, user_john])
      end
    end

    context 'with two params' do
      it 'returns the matches' do
        expect(Users::Search.by_name('mary jones').to_a).to match_array([user_mary])
        expect(Users::Search.by_name('jones mary').to_a).to match_array([user_mary])
      end
    end
  end

end
