class TangoCard

  PLATFORM_NAME = "PinyadaTest"
  PLATFORM_KEY = "k23vHRAFiMH0dGVFk7LGz9iyPbeMlV6Dm8EWHelhlqwlYLbQt808UaGwto"
  AUTHORIZATION = "Basic UGlueWFkYVRlc3Q6azIzdkhSQUZpTUgwZEdWRms3TEd6OWl5UGJlTWxWNkRtOEVXSGVsaGxxd2xZTGJRdDgwOFVhR3d0bw=="
  CUSTOMER = "PinYada"
  ACCOUNT_IDENTIFIER = "DrewCoffee"
  CLIENT_IP = "127.0.0.1"
  CC_TOKEN = "34547856"
  SECURITY_CODE = 123

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
    request["Authorization"] = AUTHORIZATION

    request.set_form_data({
      "customer" => CUSTOMER,
      "account_identifier" => ACCOUNT_IDENTIFIER,
      "amount" => @amount,
      "client_ip" => CLIENT_IP,
      "cc_token" => CC_TOKEN,
      "security_code" => SECURITY_CODE
    })

    response = http.request(request)
    return JSON.parse data.body
  end
end
