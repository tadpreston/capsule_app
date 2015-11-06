class LocationFinder < CapsuleFeedBase
  attr_accessor :point, :user_id

  def initialize latitude, longitude, user_id, offset, limit
    @point = Vincenty.new latitude, longitude
    @user_id = user_id
    super offset.to_i, limit.to_i
  end

  def capsules
    sorted_capsules = capsule_scope.map { |yada| YadaPoint.new(yada, point) }.sort { |yada_point1,yada_point2| yada_point1.distance <=> yada_point2.distance }
    sorted_capsules.map(&:yada)[offset..(offset+limit-1)]
  end

  private

  def capsule_scope
    @capsule_scope ||= Capsule.for_user(user_id).location.select { |capsule| !capsule.is_unlocked? user_id }
  end
end
