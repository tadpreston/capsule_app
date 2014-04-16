require 'spec_helper'

describe 'Capsules API' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
  end
  let(:token) { 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"' }
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

    # Commented out because for right now authentication is not required for the index
   # describe 'Not authenticated' do
   #   it 'returns unauthorized' do
   #     get '/api/v1/capsules', nil, { 'HTTP_AUTHORIZATION' => token }
   #     expect(response).to_not be_success
   #     expect(response.status).to eq(403)
   #   end
   # end
  end

  describe "POST 'create'" do
    describe 'with valid params' do
      it 'creates a new capsule and returns it' do
#        expect {
#          post '/api/v1/capsules', { capsule: { title: 'A title #title', location: { latitude: '33.189', longitude: '-96.7718', radius: '25000' } } }, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
#        }.to change(Capsule, :count).by(1)
#        expect(json['response']['capsule']).not_to be_blank
#        expect(json['response']['capsule']['id']).to eq(assigns(:capsule).id)
#        expect(json['response']['capsule']['title']).to eq(assigns(:capsule).title)
      end
    end

    describe 'with invalid params' do
      it 'returns the error message' do
#        expect {
#          post '/api/v1/capsules', { capsule: { title: '' } }, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
#        }.to_not change(Capsule, :count).by(1)
#        expect(json['response']['errors']).to_not be_blank
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
