require 'spec_helper'

describe 'Capsules API' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
  end
  let(:tenant) { FactoryGirl.create(:tenant) }
  let(:token) { "Token token=\"#{tenant.tenant_keys[0].token}\"" }
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
      capsule = FactoryGirl.create(:capsule, user: @user, tenant_id: tenant.id)
      get "/api/v1/capsules/#{capsule.to_param}", nil, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(json['response']['capsule']).to_not be_blank
    end
  end

#  describe "GET 'locationtags'" do
#    before do
#      origin = { lat: 33.18953, long: -96.87909000000002 }
#      span = { lat: 2.5359475904, long: 1.7578124096 }
#      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '999999' }, tenant_id: tenant.id)
#      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '999999' }, tenant_id: tenant.id)
#      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '33.089326', longitude: '-96.731873', radius: '999999' }, tenant_id: tenant.id)
#      get "/api/v1/capsules/locationtags", { latOrigin: origin[:lat], longOrigin: origin[:long], latSpan: span[:lat], longSpan: span[:long], hashtags: 'hellokitty' }, { format: :json, 'HTTP_AUTHORIZATION' => token, 'HTTP_CAPSULE_AUTH_TOKEN' => auth_token }
#    end
#
#    it 'returns http success' do
#      expect(response).to be_success
#      expect(response.status).to eq(200)
#    end
#
#    it 'returns the count of the capsules' do
#      expect(json['response']['capsule_count']).to eq(3)
#    end
#  end

end
