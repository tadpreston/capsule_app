require 'spec_helper'

describe 'Capsules API' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
  end
  let(:token) { 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"' }
  let(:auth_token) { @device.auth_token }

  describe 'with incorrect credentials' do
    describe 'Without an API token' do
      it 'returns unauthorized' do
        get '/api/v1/capsules'
        expect(response).to_not be_success
        expect(response.status).to eq(401)
      end
    end

    describe 'with wrong credentails' do
      it 'returns unauthorized' do
        get '/api/v1/capsules', nil, { 'HTTP_AUTHORIZATION' => 'abCD341f409' }
        expect(response).to_not be_success
        expect(response.status).to eq(401)
      end
    end

    describe 'Not authenticated' do
      it 'returns unauthorized' do
        get '/api/v1/capsules', nil, { 'HTTP_AUTHORIZATION' => token }
        expect(response).to_not be_success
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST 'create'" do
    describe 'with valid params' do
      it 'creates a new capsule and returns it' do
        expect {
          post '/api/v1/capsules', { capsule: { title: 'A title #title' } }, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
        }.to change(Capsule, :count).by(1)
        expect(json['response']['capsule']).not_to be_blank
        expect(json['response']['capsule']['id']).to eq(assigns(:capsule).id)
        expect(json['response']['capsule']['title']).to eq(assigns(:capsule).title)
      end
    end

    describe 'with invalid params' do
      it 'returns the error message' do
        expect {
          post '/api/v1/capsules', { capsule: { title: '' } }, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
        }.to_not change(Capsule, :count).by(1)
        expect(json['response']['errors']).to_not be_blank
      end
    end
  end

  describe "GET 'show'" do
    it 'returns the requested capsule' do
      capsule = FactoryGirl.create(:capsule, user: @user)
      get "/api/v1/capsules/#{capsule.to_param}", nil, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(json['response']['capsule']).to_not be_blank
    end
  end



end
