require 'spec_helper'

describe API::V1::ObjectionsController do
  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"'
    @request.env["CONTENT_TYPE"] = "application/json"
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
    @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
  end

  let(:valid_attributes) { FactoryGirl.attributes_for(:objection) }

  describe 'POST "create"' do

    describe 'an objection to a capsule' do
      before { @capsule = FactoryGirl.create(:capsule) }

      it 'creates a new objection' do
        expect {
          post :create, { capsule_id: @capsule.id, comment: 'This is bad', is_dmca: true }
        }.to change(Objection, :count).by(1)
      end

      it 'creates an objection to a capsule' do
        post :create, { capsule_id: @capsule.id, comment: 'This is bad', is_dmca: true }
        expect(@capsule.objections.count).to eq(1)
      end
    end

    describe 'an objection to a comment' do
      before { @comment = FactoryGirl.create(:comment) }

      it 'creates a new objection' do
        expect {
          post :create, { comment_id: @comment.id, comment: 'This is bad', is_dmca: true }
        }.to change(Objection, :count).by(1)
      end

      it 'creates an objection to a comment' do
        post :create, { comment_id: @comment.id, comment: 'This is bad', is_dmca: true }
        expect(@comment.objections.count).to eq(1)
      end
    end
  end
end
