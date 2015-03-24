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
    params.each { |key, value| user[key] = value unless key =~ /password/ }
    user.provider = 'capsule'
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.converted_at = DateTime.now.utc if user.persisted?
    user.save!
    user
  end

  private

  def set_user
    User.where('email = ? OR phone_number = ?', params[:email], params[:phone_number]).first || User.new
  end
end
