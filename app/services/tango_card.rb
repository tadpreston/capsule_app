class TangoCard

  PLATFORM_NAME = "PinyadaTest"
  PLATFORM_KEY = "k23vHRAFiMH0dGVFk7LGz9iyPbeMlV6Dm8EWHelhlqwlYLbQt808UaGwto"
  AUTHORIZATION = "Basic UGlueWFkYVRlc3Q6azIzdkhSQUZpTUgwZEdWRms3TEd6OWl5UGJlTWxWNkRtOEVXSGVsaGxxd2xZTGJRdDgwOFVhR3d0bw=="
  CUSTOMER = "PinYada"
  ACCOUNT_IDENTIFIER = "DrewCoffee"
  CLIENT_IP = "127.0.0.1"
  CC_TOKEN = "34547856"
  SECURITY_CODE = "123"

  def initialize(amount)
    @amount = amount
  end

  def self.fund(amount)
    new(amount).fund
  end

  def fund
    uri = URI.parse("https://sandbox.tangocard.com/raas/v1.1/cc_fund")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field("Authorization", AUTHORIZATION)
    request.add_field("Content-Type", "application/json")

    request.body = {
      "customer" => CUSTOMER,
      "account_identifier" => ACCOUNT_IDENTIFIER,
      "amount" => @amount,
      "client_ip" => CLIENT_IP,
      "cc_token" => CC_TOKEN,
      "security_code" => SECURITY_CODE
    }.to_json

    response = http.request(request)

    #	sample response
    # {
    #   "success": true,
    #   "fund_id": "115-11769822-04",
    #   "amount": 500
    # }

    if response.code == "200"
      # create CampaignTransaction
      return true
    end

    return nil
  end
end
