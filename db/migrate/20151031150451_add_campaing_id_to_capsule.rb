class AddCampaingIdToCapsule < ActiveRecord::Migration
  def change
    add_reference :capsules, :campaign, index: true
  end
end
