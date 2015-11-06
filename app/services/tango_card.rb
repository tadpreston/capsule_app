class TangoCard
  def initialize(params)
    @amount = params["amount"]
    @campaign = params["campaign"]
    @recipient = params["recipient"]
    @sku = params["sku"]
    @amount = params["amount"]
    @email = params["email"]
  end

  def self.fund(amount)
    new({ "amount" => amount }).fund
  end

  def self.place_order(campaign, recipient, sku, amount, email)
    new({ "campaign" => campaign, "recipient" => recipient, "sku" => sku, "amount" => amount, "email" => email }).place_order
  end

  def fund
    uri = URI.parse(ENV['TANGO_API_BASE_URL'] + "cc_fund")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field("Authorization", ENV['TANGO_AUTHORIZATION'])
    request.add_field("Content-Type", "application/json")

    request.body = {
      "customer" => ENV['TANGO_CUSTOMER'],
      "account_identifier" => ENV['TANGO_ACCOUNT_IDENTIFIER'],
      "amount" => @amount,
      "client_ip" => ENV['TANGO_CLIENT_IP'],
      "cc_token" => ENV['TANGO_CC_TOKEN'],
      "security_code" => ENV['TANGO_SECURITY_CODE']
    }.to_json

    response = http.request(request)

    #	sample response
    # {
    #   "success": true,
    #   "fund_id": "115-11769822-04",
    #   "amount": 500
    # }

    if response.code == "200"
      return true
    end

    return response.body
  end

  def place_order
    uri = URI.parse(ENV['TANGO_API_BASE_URL'] + "orders")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field("Authorization", ENV['TANGO_AUTHORIZATION'])
    request.add_field("Content-Type", "application/json")

    request.body = {
      "customer" => ENV['TANGO_CUSTOMER'],
      "account_identifier" => ENV['TANGO_ACCOUNT_IDENTIFIER'],
      "campaign" => @campaign,
      "recipient" => @recipient,
      "sku" => @sku,
      "amount" => @amount,
      "reward_from" => @email.from,
      "reward_subject" => @email.subject,
      "reward_message" => @email.message,
      "send_reward" => true
    }.to_json

    response = http.request(request)

    # sample response
    # {
    #   "success": true,
    #   "order": {
    #     "order_id": "115-11769842-04",
    #     "account_identifier": "DrewCoffee",
    #     "customer": "PinYada",
    #     "sku": "SBUX-E-V-STD",
    #     "denomination": {
    #       "value": 500,
    #       "currency_code": "USD"
    #     },
    #     "amount_charged": {
    #       "value": 500,
    #       "currency_code": "USD"
    #     },
    #     "reward_message": "here you go. ",
    #     "reward_subject": "A Coffee for You!",
    #     "reward_from": "PinYada",
    #     "delivered_at": "2015-11-04T05:37:32+00:00",
    #     "recipient": {
    #       "name": "A Friend",
    #       "email": "drew.j.wyatt@gmail.com"
    #     },
    #     "external_id": null,
    #     "reward": {
    #       "token": "5639999d618a45.51310409",
    #       "number": "R92JH8",
    #       "redemption_url": "https://starbucks.semi.cashstar.com/gift-card/view/ADhLToy5obxztYM0yIkgOMtRF/"
    #     }
    #   }
    # }

    response.body
  end
end
