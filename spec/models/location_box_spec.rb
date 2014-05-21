# == Schema Information
#
# Table name: location_boxes
#
#  id            :integer          not null, primary key
#  latitude      :decimal(, )
#  longitude     :decimal(, )
#  lat_median    :decimal(, )
#  long_median   :decimal(, )
#  capsule_store :hstore           default({"ids"=>"[]"})
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe LocationBox do
  pending "add some examples to (or delete) #{__FILE__}"
end
