require 'spec_helper'

describe API::V1::ConfigsController do

  describe "GET 'index'" do
    it "returns http success" do
      @request.env['HTTP_AUTHORIZATION'] = 'Token token="H4F3AHOB2jm873ESQ5KQOzQH9joWXiG00CwWqCh8fRCl33Qjq2PsW5fZ7nrN-3uW1gjBlOkxaQmxOqAiPtGO_g"'
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
