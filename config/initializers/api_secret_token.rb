require 'securerandom'

def api_secure_token
  token_file = Rails.root.join('.api_secret')
  if File.exist?(token_file)
    File.read(token_file).chomp
  else
    token = SecureRandom.urlsafe_base64(64)
    File.write(token_file, token)
    token
  end
end

CapsuleApp::Application.config.api_secret_key_base = ENV['API_SECRET']
