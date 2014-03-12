require 'spec_helper'

describe 'Sessions API' do
  before(:each) { @user = FactoryGirl.create(:user, email: 'test@email.com', password: 'supersecret', password_confirmation: 'supersecret') }

  describe "POST 'create'" do
    describe 'valid authentication' do
      it 'returns the authentication token' do
        post '/api/v1/sessions', { email: 'test@email.com', password: 'supersecret' }, format: :json
        expect(response).to be_success
        expect(json['response']['authentication_token']).not_to be_blank
      end

      it 'creates a new device session' do
        expect {
          post '/api/v1/sessions', { email: 'test@email.com', password: 'supersecret' }, format: :json
        }.to change(Device, :count).by(1)
      end

      it 'resets the existing auth_token' do
        device = FactoryGirl.create(:device, user: @user, user_agent: nil)
        orig_auth_token = device.auth_token
        post '/api/v1/sessions', { email: 'test@email.com', password: 'supersecret' }, format: :json
        device = Device.find device.id
        expect(device.auth_token).to_not eq(orig_auth_token)
      end
    end

    describe 'invalid authentication' do
      it 'returns invalid message' do
        post '/api/v1/sessions', { email: 'test@email.com', password: 'wrongpassword' }, format: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before { @device = FactoryGirl.create(:device, user: @user) }

    it 'expires the auth token' do
      delete "/api/v1/sessions/#{@device.auth_token}"
      expect(response).to be_success
      @device.reload
      expect(@device.auth_token).to be_blank
      expect(json['message']).to eq('Successfully logged out')
    end

    it 'cannot find the session' do
      delete "/api/v1/sessions/1234"
      expect(response.status).to eq(404)
      expect(json['message']).to eq('Session not found')
    end
  end
end
