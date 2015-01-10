class Apns

	fname = 'tmp.pem'
	#fkey = "pinyada_apns_development.pem"
	fkey = "pinyada_apns_production.pem"
	bname = 'capsule-app-internal'
	s3 = AWS::S3.new access_key_id: 'AKIAJKYJL5IBHFBM2OQA', secret_access_key: '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'
	bucket = s3.buckets[bname]
	obj = bucket.objects[fkey]
	File.open(fname, 'wb') do |fo|
		obj.read do |chunk|
			fo.write(chunk)
	    end
	end
	file = File.new(fname)

	# use the newly created file as the PEM file for the APNS gem
	APNS.pem = file
	APNS.host = 'gateway.push.apple.com'
	# gateway.sandbox.push.apple.com is default

	APNS.port = 2195
		# Me
		device_token = '7f6520e59526469a847666ded75ab9b7b742a92251c70c6b1d832fb2647cbe46'
		# Dalton
		#device_token = 'd688e4c02ed401f0da7e676af2943b524861db871cbc4184dd50bfaea4106948'
		APNS.send_notification(device_token, alert: 'New Push Notification!', badge: 1, sound: 'default')
	File.delete(fname)
end
