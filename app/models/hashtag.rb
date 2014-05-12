class Hashtag < ActiveRecord::Base

  def self.find_location_hashtags(params = {})
    hashtags = Hashtag.select("tag, count(tag) as tag_count").group("tag").order('tag_count DESC')
    hashtags = hashtags.where('tag ilike ?', "%#{params[:tag]}%") if params[:tag]
    if params[:origin] && params[:span]
      origin = params[:origin]
      span = params[:span]
      west_bound = origin[:long] - span[:long]
      east_bound = origin[:long] + span[:long]
      north_bound = origin[:lat] + span[:lat]
      south_bound = origin[:lat] - span[:lat]
      hashtags = hashtags.where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound))
    end
    hashtags
  end
end
