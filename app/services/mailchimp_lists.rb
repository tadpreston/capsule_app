class MailchimpLists
  attr_accessor :email, :list_id

  def initialize email, list_id
    @email = email
    @list_id = list_id
  end

  def self.subscribe(email:, list_id: ENV['MAILCHIMP_DEFAULT_LIST_ID'])
    new(email, list_id).subscribe
  end

  def self.unsubscribe(email:, list_id: ENV['MAILCHIMP_DEFAULT_LIST_ID'])
    new(email, list_id).unsubscribe
  end

  def subscribe
    lists.subscribe list_id, { email: email }
  end

  def unsubscribe
    lists.unsubscribe list_id, { email: email }
  rescue Mailchimp::ListNotSubscribedError
    nil
  end

  private

  def client
    @client ||= Mailchimp::API.new ENV['MAILCHIMP_API_KEY']
  end

  def lists
    client.lists
  end
end
