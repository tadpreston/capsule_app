class AddLikesArrayToCapsules < ActiveRecord::Migration
  def up
    add_column :capsules, :likes, :integer, array: true, default: []

    Capsule.all.each do |capsule|
      say "Capsule - ID #{capsule.id}"
      likes_array = eval(capsule.likes_store["ids"])
      capsule.update_attribute(:likes, capsule.likes + likes_array)
    end
  end

  def down
    remove_column :capsules, :likes
  end
end
