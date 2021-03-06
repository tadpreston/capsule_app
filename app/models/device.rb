# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  remote_ip       :string(255)
#  user_agent      :string(255)
#  auth_token      :string(255)
#  auth_expires_at :datetime
#  last_sign_in_at :datetime
#  session         :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

class Device < ActiveRecord::Base
  before_create :generate_auth_token

  belongs_to :user, touch: true

  def self.current_device(remote_ip, user_agent)
    find_by remote_ip: remote_ip, user_agent: user_agent
  end

  def reset_auth_token!
    generate_auth_token
    save!
  end

  def expire_auth_token!
    self.auth_token = nil
    save!
  end

  def has_token?
    auth_token
  end

  private

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64(64)
    end while Device.exists?(auth_token: self.auth_token)
  end
end
