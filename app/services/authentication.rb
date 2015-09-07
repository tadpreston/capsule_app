class Authentication

  def initialize params, request
    @params = params
    @user = get_user @params
    @request = request
  end

  def authenticated?
    return nil unless @user
    if user_is_authenticated?
      @user.reload
      update_or_create_device
      set_mode
      @user
    end
  end

  private

  def user_is_authenticated?
    if @params[:password]
      @user.authenticate @params[:password]
    else
      FacebookValidator.validate_user @params[:facebook_id], @params[:facebook_token]
    end
  end

  def get_user params
    if params[:facebook_id]
      User.find_by(facebook_username: params[:facebook_id])
    else
      User.find_by(email: params[:email]) if params[:email]
    end
  end

  def update_or_create_device
    device = @user.devices.current_device(@request.remote_ip, @request.user_agent)
    if device
      device.last_sign_in_at = Time.now
      device.reset_auth_token!
    else
      @user.devices.create(remote_ip: @request.remote_ip, user_agent: @request.user_agent, last_sign_in_at: Time.now)
    end
  end

  def set_mode
    if @params[:test]
      @user.update_attribute :mode, 'test'
    else
      @user.update_attribute :mode, ''
    end
  end
end
