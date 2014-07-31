require 'spec_helper'

describe Authentication do
  let(:request) { double("request", user_agent: 'testing', remote_ip: '1.1.1.1') }
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
      link: 'https:\/\/www.facebook.com\/steelyb',
    }
  end

  describe '#authenticated?' do
    it 'returns authenticated if username and password match' do
      FactoryGirl.create(:user, email: 'spectest@email.com', password: 'supersecret', password_confirmation: 'supersecret')
      expect(Authentication.new({email: 'spectest@email.com', password: 'supersecret'}, request)).to be_authenticated
      expect(Authentication.new({email: 'spectest@email.com', password: 'x'}, request)).to_not be_authenticated
      expect(Authentication.new({email: 'a', password: 'supersecret'}, request)).to_not be_authenticated
    end

    it 'creates a device object' do
      FactoryGirl.create(:user, email: 'spectest@email.com', password: 'supersecret', password_confirmation: 'supersecret')
      expect {
        Authentication.new({email: 'spectest@email.com', password: 'supersecret'}, request).authenticated?
      }.to change(Device, :count).by(1)
    end

    it 'updates an existing device' do
      user = FactoryGirl.create(:user, email: 'spectest@email.com', password: 'supersecret', password_confirmation: 'supersecret')
      FactoryGirl.create(:device, user: user, user_agent: 'testing', remote_ip: '1.1.1.1')
      Device.any_instance.should_receive(:reset_auth_token!)
      expect {
        Authentication.new({email: 'spectest@email.com', password: 'supersecret'}, request).authenticated?
      }.to_not change(Device, :count).by(1)
    end

    describe 'with omniauth' do
      it 'creates a new user record if one does not exist' do
        expect {
          Authentication.new({ oauth: oauth_attributes }, request).authenticated?
        }.to change(User, :count).by(1)
      end
      it 'authenticates the user' do
        expect(Authentication.new({ oauth: oauth_attributes }, request)).to be_authenticated
      end
      it 'authenticates the user if the user exists' do
        FactoryGirl.create(:user, oauth: oauth_attributes)
        expect {
          Authentication.new({ oauth: oauth_attributes }, request).authenticated?
        }.to_not change(User, :count).by(1)
        expect(Authentication.new({ oauth: oauth_attributes }, request)).to be_authenticated
      end
    end
  end
end
