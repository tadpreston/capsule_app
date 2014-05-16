require 'spec_helper'

describe API::V1::CommentsController do
  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"'
    @request.env["CONTENT_TYPE"] = "application/json"
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
    @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
    @capsule = FactoryGirl.create(:capsule)
  end

  let(:valid_attributes) { FactoryGirl.attributes_for(:comment) }

  describe 'GET "index"' do
    it "returns http success" do
      get :index, capsule_id: @capsule.to_param
      expect(response).to be_success
    end
  end

  describe 'POST "create"' do
    describe 'with valid params' do
      it 'creates a new capsule' do
        expect {
          post :create, { capsule_id: @capsule.id, comment: { body: "This is a comment" } }
        }.to change(Comment, :count).by(1)
      end

      it 'assigns a new comment as @comment' do
        post :create, { capsule_id: @capsule.id, comment: { body: "This is a comment" } }
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end
    end

  end

  describe "DELETE 'destroy'" do
    it 'deletes a comment record' do
      comment = FactoryGirl.create(:comment, user: @user, commentable: @capsule)
      expect {
        delete :destroy, { capsule_id: @capsule.to_param, id: comment.to_param }
      }.to change(Comment, :count).by(-1)
    end
  end
end
