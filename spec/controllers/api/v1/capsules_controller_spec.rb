require 'spec_helper'

describe API::V1::CapsulesController do
  before do
    @tenant = FactoryGirl.create(:tenant)
    @token = @tenant.tenant_keys[0].token
    @request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@token}\""
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
        }.to change(Capsule.unscoped, :count).by(1)
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
    # Commenting out until to rewrite the tests for the new controller logic
#    before do
#      @origin = { lat: 33.18953, long: -96.87909000000002 }
#      @span = { lat: 2.5359475904, long: 1.7578124096 }
#      @capsule1 = FactoryGirl.create(:capsule, location: { latitude: '33.167111', longitude: '-96.663793', radius: '999999' })
#      @capsule2 = FactoryGirl.create(:capsule, location: { latitude: '33.013300', longitude: '-96.823046', radius: '999999' })
#      @capsule3 = FactoryGirl.create(:capsule, location: { latitude: '30.089326', longitude: '-96.231873', radius: '999999' })
#    end
#
#    it 'returns http success' do
#      get :explorer, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long] }
#      expect(response).to be_success
#      expect(response.status).to eq(200)
#    end
#
#    it 'returns an ordered collection of capsules in @capsules' do
#      get :explorer, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long] }
#      expect(assigns(:capsules)).to_not be_empty
#      expect(assigns(:capsules)).to eq([@capsule2, @capsule1])
#      expect(assigns(:capsules)).to_not include(@capsule3)
#    end
#
#    it 'returns an ordered collection of capsules in @capsules with a tag' do
#      tag = @capsule1.hash_tags.split(' ')[0]
#      get :explorer, { latOrigin: @origin[:lat], longOrigin: @origin[:long], latSpan: @span[:lat], longSpan: @span[:long], hashtag: tag }
#      expect(assigns(:capsules)).to_not be_empty
#      expect(assigns(:capsules)).to eq([@capsule2, @capsule1])
#      expect(assigns(:capsules)).to_not include(@capsule3)
#    end
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

      @user.watch_capsule @capsule1
      @user.watch_capsule @capsule3
      @user.watch_capsule @capsule4
    end

    it 'returns a collection of watched capsules for the current user' do
      get :watched
      expect(assigns(:capsules)).to_not be_nil
    end
  end

  describe 'GET "show"' do
    before do
      @capsule = FactoryGirl.create(:capsule, user: @user, tenant_id: @tenant.id)
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
    before { @capsule = FactoryGirl.create(:capsule, user: @user, tenant_id: @tenant.id) }

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

  describe 'GET "forme"' do
    before do
      @capsule_list = FactoryGirl.create_list(:capsule, 3, tenant_id: @tenant.id)
      @capsule_list.each { |c| c.recipients << @user }
    end

    it "assigns the capsules to @capsules" do
      get :forme
      expect(assigns(:capsules)).to_not be_nil
    end

    it "returns capsules for the current user" do
      get :forme
      expect(assigns(:capsules).size).to eq(@capsule_list.size)
      @capsule_list.each { |capsule| expect(assigns(:capsules)).to include(capsule) }
    end
  end

  describe 'GET "suggested"' do
    it 'returns a collection of suggested capsules for the current user' do
      FactoryGirl.create_list(:capsule, 3, latitude: 32.7801399, longitude: -96.80045101, tenant_id: @tenant.id)
      FactoryGirl.create_list(:capsule, 3, latitude: 32.7554883, longitude: -97.3307658, tenant_id: @tenant.id)
      outside_capsules = FactoryGirl.create_list(:capsule, 3, latitude: 35.2219971, latitude: -101.83129689, tenant_id: @tenant.id)

      get :suggested
      expect(assigns(:capsules)).to_not be_nil
      expect(assigns(:capsules).size).to eq(5)
#     expect(outside_capsules).to match_array(assigns(:capsules))
    end
  end

  describe 'GET "library"' do
    it 'returns a collection of capsules for the library' do
      get :library
      expect(assigns(:watched_capsules)).to_not be_nil
      expect(assigns(:capsules_forme)).to_not be_nil
      expect(assigns(:suggested_capsules)).to_not be_nil
    end
  end

  describe 'GET "replies"' do
    before { @capsule = FactoryGirl.create(:capsule, tenant_id: @tenant.id) }

    it 'returns a collection of replied capsules' do
      capsule_list = FactoryGirl.create_list(:capsule, 3, in_reply_to: @capsule.id, tenant_id: @tenant.id)

      get :replies, id: @capsule.to_param
      expect(assigns(:capsules)).to_not be_nil
      expect(assigns(:capsules).to_a).to match_array(capsule_list)
    end

    it 'returns an empty collection' do
      get :replies, id: @capsule.to_param
      expect(assigns(:capsules)).to be_empty
    end
  end

  describe "GET 'replied_to'" do
    before { @capsule = FactoryGirl.create(:capsule, tenant_id: @tenant.id) }

    it 'returns the capsule that the current capsule replied to' do
      reply_capsule = FactoryGirl.create(:capsule, in_reply_to: @capsule.id, tenant_id: @tenant.id)
      get :replied_to, id: reply_capsule.to_param
      expect(assigns(:capsule)).to_not be_nil
      expect(assigns(:capsule)).to eq(@capsule)
    end

    it 'returns nil if there is no replied_to' do
      get :replied_to, id: @capsule.to_param
      expect(assigns(:capsule)).to be_nil
    end
  end

  describe "POST 'read'" do
    before { @capsule = FactoryGirl.create(:capsule, tenant_id: @tenant.id) }

    it 'creates a capsule_read record' do
      post :read, id: @capsule.to_param
      expect(assigns(:capsule).read_by?(@user)).to be_true
    end
  end

  describe "DELETE 'unread'" do
    before { @capsule = FactoryGirl.create(:capsule, tenant_id: @tenant.id) }

    it 'deletes a read mark for the current user' do
      @capsule.read @user
      delete :unread, id: @capsule.to_param
      expect(assigns(:capsule).read_by?(@user)).to be_false
    end
  end

end
