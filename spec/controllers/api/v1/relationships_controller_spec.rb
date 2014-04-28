require 'spec_helper'

describe API::V1::RelationshipsController do
  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"'
    @request.env["CONTENT_TYPE"] = "application/json"
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
    @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
    @other_user = FactoryGirl.create(:user)
  end

  describe "POST 'create'" do
    it 'creates a relationship record' do
      expect {
        post :create, { relationship: { follow_id: @other_user.id } }
      }.to change(Relationship, :count).by(1)
      expect(@user).to be_following(@other_user)
    end
  end

  describe "DELETE 'destroy'" do
    it 'deletes a relationship record' do
      @user.follow!(@other_user)
      expect {
        delete :destroy, { id: @other_user.to_param }
      }.to change(Relationship, :count).by(-1)
      expect(@user).to_not be_following(@other_user)
    end
  end
end
