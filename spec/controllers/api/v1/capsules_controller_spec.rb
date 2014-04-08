require 'spec_helper'

describe API::V1::CapsulesController do
  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
    @request.env["CONTENT_TYPE"] = "application/json"
    @user = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device, user: @user)
    @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
  end

  let(:valid_attributes) { FactoryGirl.attributes_for(:capsule) }

  describe 'POST "create"' do
    describe 'with valid params' do
      it 'creates a new capsule' do
        expect {
          post :create, { capsule: valid_attributes.merge(user_id: @user.id) }
        }.to change(Capsule, :count).by(1)
      end

      it 'assigns a new capsule as @capsule' do
        post :create, { capsule: valid_attributes.merge(user_id: @user.id) }
        assigns(:capsule).should be_a(Capsule)
        assigns(:capsule).should be_persisted
      end
    end

    describe 'with invalid params' do
      it "assigns newly created but unsaved capsule as @capsule" do
        Capsule.any_instance.stub(:save).and_return(false)
        post :create, { capsule: { title: '' } }
        expect(assigns(:capsule)).to be_a_new(Capsule)
      end
    end
  end

  describe 'GET "show"' do
    before do
      @capsule = FactoryGirl.create(:capsule, user: @user)
      get :show, id: @capsule.to_param
    end

    it 'returns http success' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'assigns capsule to @capsule' do
      expect(assigns(:capsule)).to eq(@capsule)
    end
  end

  describe 'PATCH "update"' do
    before { @capsule = FactoryGirl.create(:capsule, user: @user) }

    describe 'with valid params' do
      it 'updates the requested capsule' do
        Capsule.any_instance.should_receive(:update_attributes)
        patch :update, id: @capsule.to_param, capsule: { title: 'A changed title' }
      end

      it 'assigns the requested capsule to @capsule' do
        patch :update, id: @capsule.to_param, capsule: { title: 'A changed title' }
        expect(assigns(:capsule)).to eq(@capsule)
      end
    end

    describe "with invalid params" do
      it "assigns the capsule as @capsule" do
        Capsule.any_instance.stub(:update_attributes).and_return(false)
        patch :update, id: @capsule.to_param, capsule: { title: '' }
        assigns(:capsule).should eq(@capsule)
      end
    end
  end
end
