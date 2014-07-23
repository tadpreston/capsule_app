# == Schema Information
#
# Table name: location_watches
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  longitude  :decimal(, )
#  latitude   :decimal(, )
#  radius     :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class LocationWatch < ActiveRecord::Base
  after_destroy LocationWatchCallbacks

  belongs_to :user, touch: true

  def self.location_watches(user_id)
    sql = <<-SQL
      SELECT row_to_json(c) AS watch_json
      FROM (
        SELECT id, latitude::Text, longitude::Text, radius::Text, created_at, updated_at
        FROM location_watches
        WHERE user_id = #{user_id}
      ) c;
    SQL
    find_by_sql sql
  end
end
