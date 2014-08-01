require 'spec_helper'

describe API::V1::ConfigsController do

  describe "GET 'index'" do
    it "returns http success" do
      @tenant = FactoryGirl.create(:tenant)
      @token = @tenant.tenant_keys[0].token
      @request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@token}\""
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
end
