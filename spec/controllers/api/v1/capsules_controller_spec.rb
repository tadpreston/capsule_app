require 'spec_helper'

describe API::V1::CapsulesController do
  before do
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="yd18uk_gsB7xYByZ03CX_TkgYjfGdxPRNhNswXjNLajw9itey64rlt9A-m7K4yQSC_-DHkicd9oVUvErRav48w"'
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

    # TODO Rethink these tests... Are they necessary? Are they testing the right thing?
    #describe 'with recipients' do
    #  before do
    #    recipients_attributes = [{ phone_number: '2145551212', email: 'bobdylan@gmail.com' }]
    #    post :create, { capsule: valid_attributes.merge({user_id: @user.id, recipients_attributes: recipients_attributes}) }
    #  end

    #  it "creates a user" do
    #    expect(User.exists?(phone_number: '2145551212')).to be_true
    #  end

    #  it "adds user as a contact" do
    #    expect(@user.contacts.exists?(phone_number: '2145551212')).to be_true
    #  end

    #  it "adds user as a recipient" do
    #    expect(assigns(:capsule).recipients.exists?(phone_number: '2145551212')).to be_true
    #  end
    #end
  end

  describe 'GET "explorer"' do
    before do
      @origin = { lat: 33.18953, long: -96.87909000000002 }
      @span = { lat: 2.5359475904, long: 1.7578124096 }
      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '999999' })
      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '999999' })
      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '30.089326', longitude: '-96.231873', radius: '999999' })
    end

    it 'returns http success' do
      get :explorer, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long] }
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'returns an ordered collection of capsules in @capsules' do
      get :explorer, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long] }
      expect(assigns(:capsules)).to_not be_empty
      expect(assigns(:capsules)).to eq([@capsule2, @capsule1])
      expect(assigns(:capsules)).to_not include(@capsule3)
    end
  end

  describe 'GET "locationtags"' do
    before do
      @origin = { lat: 33.18953, long: -96.87909000000002 }
      @span = { lat: 2.5359475904, long: 1.7578124096 }
      get :locationtags, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long], hashtags: 'hellokitty' }
    end

    it 'returns http success' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'assigns the results to @capsules' do
      expect(assigns(:capsules)).to_not be_nil
    end

  end

  describe 'GET "watched"' do
    before do
      @capsule1 = FactoryGirl.create(:capsule)
      @capsule2 = FactoryGirl.create(:capsule)
      @capsule3 = FactoryGirl.create(:capsule)
      @capsule4 = FactoryGirl.create(:capsule)

      @capsule1.update_columns(updated_at: 2.days.ago)
      @capsule3.update_columns(updated_at: 3.days.ago)
      @capsule4.update_columns(updated_at: 1.days.ago)

      @user.favorite_capsules << @capsule1
      @user.favorite_capsules << @capsule3
      @user.favorite_capsules << @capsule4
    end

    it 'returns a collection of watched capsules for the current user' do
      get :watched
      expect(assigns(:capsules)).to_not be_nil
      expect(assigns(:capsules)).to eq([@capsule4, @capsule1, @capsule3])
      expect(assigns(:capsules)).to_not include(@capsule2)
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
