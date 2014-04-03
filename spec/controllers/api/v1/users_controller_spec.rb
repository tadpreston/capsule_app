require 'spec_helper'

describe API::V1::UsersController do

  let(:oauth_attributes) do
    {
      provider: 'facebook',
      uid: '1234567',
      info: {
        nickname: 'jbloggs',
        email: 'joe@bloggs.com',
        name: 'Joe Bloggs',
        first_name: 'Joe',
        last_name: 'Bloggs',
        image: 'http://graph.facebook.com/1234567/picture?type=square',
        urls: { facebook: 'http://www.facebook.com/jbloggs' },
        location: 'Frisco, Texas',
        verified: 'true'
      },
      credentials: {
        token: 'UsMu-C1OO_ExEqKqaR47TEdAyb',
        expirec_at: 1321747205,
        expires: true
      },
      extra: {
        raw_info: {
          id: '1234567',
          name: 'Joe Bloggs',
          first_name: 'Joe',
          last_name: 'Bloggs',
          link: 'http://www.facebook.com/jbloggs',
          username: 'jbloggs',
          location: { id: '123456789', name: 'Fricso, Texas' },
          gender: 'male',
          email: 'joe@bloggs.com',
          timezone: -6,
          locale: 'en_US',
          verified: true,
          updated_time: '2011-11-11T06:21:03+0000'
        }
      }
    }
  end
  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
      @request.env["CONTENT_TYPE"] = "application/json"
      get 'index'
      expect(response).to be_success
    end

    it "returns 401 unauthorized" do
      get 'index'
      response.should_not be_success
      expect(response).to_not be_success
      expect(response.status).to eq(401)
    end
  end

  describe "GET 'show'" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
      @request.env["CONTENT_TYPE"] = "application/json"
      @user = FactoryGirl.create(:user)
      @user.reload
    end

    it "returns http success" do
      get 'show', id: @user.public_id
      expect(response).to be_success
    end

    it 'assigns user to @user' do
      get 'show', id: @user.public_id
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "POST 'create'" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
      @request.env["CONTENT_TYPE"] = "application/json"
    end

    describe 'with valid params' do
      it 'creates a new user' do
        expect {
          post 'create', { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'creates a new user with oauth' do
        expect {
          post 'create', { user: valid_attributes.merge(oauth: oauth_attributes) }
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post 'create', { user: valid_attributes }
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it 'creates a new device record' do
        expect {
          post 'create', { user: valid_attributes }
        }.to change(Device, :count).by(1)
      end
    end

    describe 'with invalid params' do
      before do
        User.any_instance.stub(:save).and_return(false)
        post 'create', { :user => { :email => '', :username => '' } }
      end

      it "assigns a newly created but unsaved user as @user" do
        assigns(:user).should be_a_new(User)
      end

      it "does not create a device record" do
        expect {
          post 'create', { :user => { :email => '', :username => '' } }
        }.to_not change(Device, :count).by(1)
      end
    end
  end

  describe "PATCH 'update'" do
    before do
      @user = FactoryGirl.create(:user)
      @user.reload
      @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
      @request.env["CONTENT_TYPE"] = "application/json"
    end

    describe 'without authentication token' do
      it 'returns unauthenticated' do
        patch :update, id: @user.public_id, user: { first_name: '' }
        expect(response).to_not be_success
        expect(response.status).to eq(401)
      end
    end

    describe 'with authentication token' do
      before(:each) do
        device = FactoryGirl.create(:device, user: @user)
        @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = device.auth_token
      end

      describe "with valid params" do
        it "updates the requested user" do
          User.any_instance.should_receive(:update_attributes)
          patch :update, id: @user.public_id, user: { first_name: '' }
        end

        it "assigns the requested user as @user" do
          patch :update, id: @user.public_id, user: { first_name: '' }
          assigns(:user).should eq(@user)
        end
      end

      describe "with invalid params" do
        it "assigns the use as @user" do
          User.any_instance.stub(:update_attributes).and_return(false)
          patch :update, id: @user.public_id, user: { first_name: '' }
          assigns(:user).should eq(@user)
        end
      end
    end
  end
end
