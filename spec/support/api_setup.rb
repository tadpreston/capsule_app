def api_setup
  @tenant = FactoryGirl.create(:tenant)
  @token = @tenant.tenant_keys[0].token
  @request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@token}\""
  @request.env["CONTENT_TYPE"] = "application/json"
  @user = FactoryGirl.create(:user)
  @device = FactoryGirl.create(:device, user: @user)
  @request.env['HTTP_CAPSULE_AUTH_TOKEN'] = @device.auth_token
end
