class FacebookGraphAPI
  module GET
  @@base_url = 'https://graph.facebook.com'
  @@api_version = 'v2.4'

  module_function
    def me token, fields
	    url = "#{@@base_url}/#{@@api_version}/me?access_token=#{token}&fields=#{fields}"
	    uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
	    http.use_ssl = true

      data = http.get(uri.request_uri)

      return JSON.parse data.body
    end
  end
end
