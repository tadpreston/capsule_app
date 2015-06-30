class TokenGenerator
  attr_accessor :object, :column, :token

  def initialize object: object, column: column
    @object = object
    @column = column.to_s
  end

  def generate
    begin
      @token = SecureRandom.urlsafe_base64(64)
    end while klass.exists?(column => token)
    token
  end

  private

  def klass
    object.class.to_s.constantize
  end
end
