class OauthHash
  def initialize(orig_hash)
    @orig_hash = orig_hash
  end

  def to_json
    case @orig_hash["provider"]
    when "facebook"
      facebook
    when "twitter"
      twitter
    when "google"
      puts "<<<<< HI THERE >>>>"
      google
    end
  end

  protected

    def facebook
      location = eval(@orig_hash["location"])
      offset = @orig_hash["timezone"].to_i
      timezone = ActiveSupport::TimeZone.us_zones[offset].nil? ? ActiveSupport::TimeZone[offset].name : ActiveSupport::TimeZone.us_zones[offset].name
      {
        provider: 'facebook',
        uid: @orig_hash["uid"],
        email: @orig_hash["email"],
        username: @orig_hash["username"],
        first_name: @orig_hash["first_name"],
        last_name: @orig_hash["last_name"],
        location: location["name"],
        timezone: timezone,
        locale: @orig_hash["locale"],
        profile_image: ''
      }.with_indifferent_access
    end

    def twitter
      email = @orig_hash["email"].blank? ? '' : @orig_hash["email"]
      full_name = @orig_hash["name"].split(' ')
      {
        provider: "twitter",
        uid: @orig_hash["uid"],
        email: email,
        username: @orig_hash["screen_name"],
        first_name: full_name[0],
        last_name: full_name[1] || '',
        location: @orig_hash["location"],
        timezone: @orig_hash["time_zone"],
        locale: @orig_hash["lang"],
        profile_image: @orig_hash["profile_image_url"]
      }.with_indifferent_access
    end

    def google
      emails = eval(@orig_hash["emails"])
      email = emails[0]["value"]
      name = eval(@orig_hash["name"])
      image = eval(@orig_hash["image"])

      {
        provider: "google",
        uid: @orig_hash["uid"],
        email: email,
        username: email,
        first_name: name["givenName"],
        last_name: name["familyName"],
        location: '',
        timezone: '',
        locale: @orig_hash["language"],
        profile_image: image["url"]
      }.with_indifferent_access
    end
end
