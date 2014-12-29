# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  capsule_id        :integer
#  message           :text
#  notification_type :text
#  delivery_type     :text
#  notified          :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
