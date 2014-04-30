require 'spec_helper'

describe API::V1::SessionsController do

  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"'
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  describe "POST 'create'" do
    describe "with username and password" do

      before(:each) do
        @user = FactoryGirl.create(:user, email: 'spectest@email.com', password: 'supersecret', password_confirmation: 'supersecret')
      end

      describe "valid credentials" do
        let(:valid_credentials) { { email: 'spectest@email.com', password: 'supersecret' } }

        it 'returns http success' do
          post :create, valid_credentials
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'creates a new device record since one does not exist' do
          expect {
            post :create, valid_credentials
          }.to change(Device, :count).by(1)
        end

        it 'updates an existing device record if one exists' do
          device = FactoryGirl.create(:device, user: @user)
          post :create, valid_credentials
        end

        it 'assigns user to @user and device to @device' do
          post :create, valid_credentials
          expect(assigns(:user)).to eq(@user)
          expect(assigns(:device)).to_not be_nil
        end
      end

      describe "invalid credentials" do
        let(:invalid_credentials) { { email: 'spectest@email.com', password: 'incorrect' } }

        it 'returns unauthorized with unknown email' do
          post :create, { email: 'invalidemail', password: 'supersecret' }
          expect(response).to_not be_success
          expect(response.status).to eq(401)
        end

        it 'returns unauthorized with bad password' do
          post :create, { email: 'spectest@email.com', password: 'invalidpassword' }
          expect(response).to_not be_success
          expect(response.status).to eq(401)
        end
      end
    end

    describe "with oauth params" do
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

      describe "user exists" do
        before { @user = FactoryGirl.create(:user, oauth: oauth_attributes) }

        it 'returns http success' do
          post :create, { oauth: oauth_attributes }
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'creates a new device record since one does not exist' do
          expect {
            post :create, { oauth: oauth_attributes }
          }.to change(Device, :count).by(1)
        end

        it 'updates an existing device record if one exists' do
          device = FactoryGirl.create(:device, user: @user)
          post :create, { oauth: oauth_attributes }
          expect(assigns(:device).auth_token).to_not eq(device.auth_token)
        end
      end

      describe "user does not exist" do
        before do
          @oauth_attrs = oauth_attributes
          @oauth_attrs[:uid] = '4567890'
        end

        it 'creates user' do
          expect {
            post :create, { oauth: @oauth_attrs }
          }.to change(User, :count).by(1)
        end

        it 'sends a confirmation email' do
          UserMailer.should_receive(:email_confirmation).and_return(double("Mailer", deliver: true))
          post :create, { oauth: @oauth_attrs }
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    before { @device = FactoryGirl.create(:device) }

    it 'removes the current auth_token' do
      delete :destroy, {:id => @device.auth_token}
      @device.reload
      expect(@device.auth_token).to be_blank
    end

    it 'returns an error if device is not found' do
      delete :destroy, {:id => '12345ABCS'}
      expect(response).to_not be_success
      expect(response.status).to eq(404)
    end
  end
end
