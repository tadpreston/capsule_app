module Tokens
  def self.generate_token(klass, object, column)
    begin
      object[column] = SecureRandom.urlsafe_base64
    end while klass.exists?(column => object[column])
  end
end
