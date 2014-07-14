envelope(json, :success) do
  json.set! :byme do
    max_time = 0
    min_time = 1000
    max_id = 0
    min_id = 0
    count = 0
    total_build_time = 0
    json.array! @capsules do |capsule|
      time_part_start = 0
      time_part_end = 0
      total_part_build = 0
        time_part_start = Time.new
        json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
        time_part_end = Time.new
#      json.cache! ['api/v1/_min_capsule', capsule] do
#      end
      json.is_watched capsule.watched_by?(current_user)
      json.is_read capsule.read_by?(current_user)
      json.is_owned is_owned?(capsule.user_id)
      total_part_build = (time_part_end - time_part_start)
      Rails.logger.debug "****** Capsule #{capsule.id} partial build time = #{total_part_build * 1000}ms"
      count += 1
      total_build_time += total_part_build
      if total_part_build > max_time
        max_time = total_part_build
        max_id = capsule.id
      elsif total_part_build < min_time
        min_time = total_part_build
        min_id = capsule.id
      end
    end
    Rails.logger.debug "**** Total build time = #{total_build_time * 1000}ms"
    Rails.logger.debug "**** Total capsules = #{count}"
    Rails.logger.debug "**** Average partial build = #{(total_build_time / count) * 1000}ms"
    Rails.logger.debug "**** Slowest partial = #{max_id} / #{max_time * 1000}ms"
    Rails.logger.debug "**** Fastest partial = #{min_id} / #{min_time * 1000}ms"
  end
#  json.set! :watched do
#    json.set! :capsules do
#      json.array! @watched_capsules do |capsule|
#        json.cache! ['api/v1/_min_capsule', capsule] do
#          json.partial! 'api/v1/capsules/min_capsule', capsule: capsule
#        end
#        json.is_watched capsule.watched_by?(current_user)
#        json.is_read capsule.read_by?(current_user)
#        json.is_owned is_owned?(capsule.user_id)
#      end
#    end
#    json.set! :locations do
#      json.array! @watched_locations do |location|
#        json.partial! 'api/v1/location_watches/location_watch', location_watch: location
#      end
#    end
#    json.set! :users do
#      json.array! @following do |user|
#        json.partial! 'api/v1/users/array_user', user: user
#      end
#    end
#  end
#  json.set! :followers do
#    json.array! @followers do |user|
#      json.partial! 'api/v1/users/array_user', user: user
#    end
#  end

end
