require 'spec_helper'

describe API::V1::ContactsController do
  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }
  let(:token) { 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"' }
  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, user: user) }

  describe "User is not authenticated" do
    it "returns 403 forbidden" do
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"

      get :index, user_id: user.to_param
      expect(response).to_not be_success
      expect(response.status).to eq(403)

      post :create, user_id: user.to_param
      expect(response).to_not be_success
      expect(response.status).to eq(403)

      delete :destroy, { user_id: user.to_param, id: 1234 }
      expect(response).to_not be_success
      expect(response.status).to eq(403)
    end
  end

  describe "GET 'index'" do
    before do
      @contact = FactoryGirl.create(:user)
      user.add_as_contact @contact
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = device.auth_token
    end

    it 'returns HTTP success' do
      get :index, user_id: user.to_param
      expect(response).to be_success
    end

    it 'assigns the collection to @contacts' do
      get :index, user_id: user.to_param
      expect(assigns(:contacts)).to_not be_nil
      expect(assigns(:contacts).size).to eq(1)
    end
  end

  describe "POST 'create'" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = device.auth_token
    end

    it "creates a new user and adds as a contact" do
      expect {
        post :create, { user_id: user.to_param, contact: { phone_number: '2145551212', email: 'test@test.com', first_name: 'Test', last_name: 'Person' } }
      }.to change(User, :count).by(1)
      expect(user.is_a_contact?(assigns(:contact))).to be_true
    end

    it "adds an existing user as a contact" do
      new_user = FactoryGirl.create(:user, phone_number: '5015551212')
      expect {
        post :create, { user_id: user.to_param, contact: { phone_number: new_user.phone_number } }
      }.to_not change(User, :count).by(1)
      expect(user.is_a_contact?(new_user)).to be_true
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = device.auth_token
    end

    it 'removes a contact from a user' do
      new_user = FactoryGirl.create(:user, phone_number: '5015551212')
      user.add_as_contact(new_user)
      expect {
        delete :destroy, { user_id: user.to_param, id: new_user.to_param }
      }.to_not change(User, :count).by(-1)
      expect(user.is_a_contact?(new_user)).to be_false
    end
  end
end
