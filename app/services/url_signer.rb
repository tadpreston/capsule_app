class UrlSigner
  attr_accessor :url

  def initialize url
    @url = url
    @signer = AwsCfSigner.new(ENV['CF_PRIVATE_KEY'], ENV['KEY_PAIR_ID'])
  end

  def signed_url
    @signer.sign url, ending: 7.days.from_now
  end
end
