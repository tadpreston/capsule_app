class Authentication

  def initialize(params, request)
    @params = params
    @user = get_user(@params)
    @request = request
  end

  def authenticated?
    if @user && @user.authenticate(@params[:password])
      @user.reload
      device = @user.devices.current_device(@request.remote_ip, @request.user_agent)
      if device
        device.last_sign_in_at = Time.now
        device.reset_auth_token!
      else
        device = @user.devices.create(remote_ip: @request.remote_ip, user_agent: @request.user_agent, last_sign_in_at: Time.now)
      end
      @user
    end
  end

  private

    def get_user(params)
      if params[:email]
        User.find_by(email: params[:email])
      elsif params[:oauth]
        Users::Search.find_or_create_by_oauth(params[:oauth])
      end
    end
end
