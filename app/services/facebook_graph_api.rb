class FacebookGraphAPI
	module GET
		module_function
		def me(token, params)
			uri = URI.parse('https://graph.facebook.com/v2.4/me')
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
			data = http.get(uri.request_uri)
			return data.body		
		end
	end
end