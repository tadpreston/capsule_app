class TangoEmail
  attr_accessor :from, :subject, :message

  def initialize(from, subject, message)
    @from = from
    @subject = subject
    @message = message
  end
end
