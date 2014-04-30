require 'spec_helper'

describe API::V1::UsersController do

  let(:oauth_attributes) do
    {
      location: {
        id: '113407485335936',
        name: 'Frisco, Texas'
      },
      timezone: -5,
      updated_time: '2014-03-02T16:01:04+0000',
      name: 'Joe Bloggs',
      email: 'joe@bloggs.com',
      birthday: '06\/14\/1978',
      locale: 'en_US',
      first_name: 'Joe',
      username: 'jbloggs',
      id: '1234567',
      provider: 'facebook',
      uid: '1234567',
      gender: 'male',
      last_name: 'Bloggs',
      hometown: {
        id: '987654321',
        name: 'Frisco, Texas'
      },
      link: 'https:\/\/www.facebook.com\/steelyb',
    }
  end
  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }
  let(:token) { 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"' }

  describe "GET 'index'" do
    it "returns http success" do
      @request.env['HTTP_AUTHORIZATION'] = token
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
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      @user = FactoryGirl.create(:user)
      @user.reload
    end

    it "returns http success" do
      get 'show', id: @user.to_param
      expect(response).to be_success
    end

    it 'assigns user to @user' do
      get 'show', id: @user.to_param
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "POST 'create'" do
    before do
      @request.env['HTTP_AUTHORIZATION'] = token
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
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
    end

    describe 'without authentication token' do
      it 'returns unauthenticated' do
        patch :update, id: @user.to_param, user: { first_name: '' }
        expect(response).to_not be_success
        expect(response.status).to eq(403)
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
          patch :update, id: @user.to_param, user: { first_name: '' }
        end

        it "assigns the requested user as @user" do
          patch :update, id: @user.to_param, user: { first_name: '' }
          assigns(:user).should eq(@user)
        end
      end

      describe "with invalid params" do
        it "assigns the use as @user" do
          User.any_instance.stub(:update_attributes).and_return(false)
          patch :update, id: @user.to_param, user: { first_name: '' }
          assigns(:user).should eq(@user)
        end
      end

      describe "with a different email" do
        it "updates the unconfirmed_email and the email columns" do
          User.any_instance.stub(:send_confirmation_email)
          original_email = @user.email
          patch :update, id: @user.to_param, user: { email: 'anew@email.com' }
          expect(assigns(:user).unconfirmed_email).to eq('anew@email.com')
          expect(assigns(:user).email).to eq(original_email)
        end

        it "sends a confirmation email" do
          User.any_instance.should_receive(:send_confirmation_email)
          patch :update, id: @user.to_param, user: { email: 'anew@email.com' }
        end
      end

      describe "with the same email" do
        it "sends a confirmation if the email param is present" do
          User.any_instance.should_receive(:send_confirmation_email)
          patch :update, id: @user.to_param, user: { email: @user.email }
        end
      end

      describe "without an email present" do
        it "does not send out an email" do
          User.any_instance.should_not_receive(:send_confirmation_email)
          patch :update, id: @user.to_param, user: { last_name: 'something' }
        end
      end
    end
  end

  describe "GET 'following'" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user = FactoryGirl.create(:user)
      @user.reload
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      @user.follow! other_user
    end

    it 'assigns the following users to @users' do
      get :following, id: @user.to_param
      expect(assigns(:users)).to_not be_nil
      expect(assigns(:users)).to include(other_user)
    end
  end

  describe "GET 'followers'" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user = FactoryGirl.create(:user)
      @user.reload
      @request.env['HTTP_AUTHORIZATION'] = token
      @request.env["CONTENT_TYPE"] = "application/json"
      other_user.follow! @user
    end

    it 'assigns the following users to @users' do
      get :followers, id: @user.to_param
      expect(assigns(:users)).to_not be_nil
      expect(assigns(:users)).to include(other_user)
    end
  end

end
