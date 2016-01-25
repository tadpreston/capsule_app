# == Schema Information
#
# Table name: admin_users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  auth_token      :string(255)
#

require 'spec_helper'

describe AdminUser do
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password) }

  describe '.authenticate_user' do
    subject(:admin_user) { AdminUser.authenticate_user email: email, password: password }

    before do
      AdminUser.create email: 'some@email.com', password: 'supersecret'
    end

    context 'with valid credentials' do
      let(:email) { 'some@email.com' }
      let(:password) { 'supersecret' }

      it 'authenticates the user' do
        expect(admin_user).to_not be_nil
      end
      it 'updates the auth_token' do
        user_object = admin_user
        expect(user_object.auth_token).to_not be_nil
      end
    end

    context 'with invalid email' do
      let(:email) { 'bob@bob.com' }
      let(:password) { 'supersecret' }

      it 'returns not authenticated' do
        expect(admin_user).to be_nil
      end
    end

    context 'with invalid password' do
      let(:email) { 'some@email.com' }
      let(:password) { 'badpassword' }

      it 'returns not authenticated' do
        expect(admin_user).to be_nil
      end
    end
  end

  describe '#generate_auth_token' do
    let!(:admin_user_object) { AdminUser.create email: 'some@email.com', password: 'supersecret' }
    subject(:admin_user) { admin_user_object.generate_auth_token }
    it 'generates the token' do
      admin_user
      expect(admin_user_object.auth_token).to_not be_nil
    end
    it 'calls SecureRandom.urlsafe_base64' do
      expect(SecureRandom).to receive(:urlsafe_base64).and_return 'an_auth_token'
      admin_user
    end
  end
end
