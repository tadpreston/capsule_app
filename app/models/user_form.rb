class UserForm
  attr_reader :params, :user

  def self.create_user params
    user_form = new params
    user_form.update
  end

  def initialize params
    @params = params
    @user = set_user
  end

  def update
    params.each { |key, value| user[key] = value unless key =~ /password|facebook_token/ }
    user.provider = 'capsule'

    if FacebookValidator.validate_user params[:facebook_id], params[:facebook_token]
      tmp_pwd = SecureRandom.hex
      user.password, user.password_confirmation = tmp_pwd, tmp_pwd
    else
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
    end

    user.converted_at = DateTime.now.utc if user.persisted?
    user.save!
    user
  end

  private

  def set_user
    User.where('email = ? OR phone_number = ?', params[:email], params[:phone_number]).first || User.new
  end

  def set_new_user
    @user = User.new user_params
    if FacebookValidator.validate @params[:facebook_id], @params[:facebook_token]
      tmp_pwd = SecureRandom.hex
      @user.password, @user.password_confirmation = tmp_pwd, tmp_pwd
    end
  end
end
