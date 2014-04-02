require 'spec_helper'

describe API::V1::SessionsController do

  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
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
        it 'creates user' do
          oauth_attrs = oauth_attributes
          oauth_attrs[:uid] = '4567890'
          expect {
            post :create, { oauth: oauth_attrs }
          }.to change(User, :count).by(1)
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
