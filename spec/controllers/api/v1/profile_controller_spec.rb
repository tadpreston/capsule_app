require 'spec_helper'

describe API::V1::ProfileController do
  let(:token) { 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"' }

  before do
    @request.env['HTTP_AUTHORIZATION'] = token
    @request.env["CONTENT_TYPE"] = "application/json"
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
    @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
  end

  describe 'GET "index"' do
    it 'gets the user from the current_user' do
      get :index
      expect(assigns(:user)).to eq(@user)
    end

    it 'gets another user if id is supplied' do
      other_user = FactoryGirl.create(:user)
      get :index, id: other_user.to_param
      expect(assigns(:user)).to eq(other_user)
    end

    it 'assigns collections' do
      get :index
      expect(assigns(:capsules)).to_not be_nil
      expect(assigns(:watched_capsules)).to_not be_nil
      expect(assigns(:watched_locations)).to_not be_nil
      expect(assigns(:following)).to_not be_nil
      expect(assigns(:followers)).to_not be_nil
    end
  end
end