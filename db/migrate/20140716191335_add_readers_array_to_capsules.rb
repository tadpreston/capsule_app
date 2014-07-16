class AddReadersArrayToCapsules < ActiveRecord::Migration
  def up
    add_column :capsules, :readers, :integer, array: true, default: []

    CapsuleRead.all.each do |reader|
      if capsule = reader.capsule
        say "Capsule ID - #{capsule.id}"
        capsule.update_attributes(readers: capsule.readers + [reader.user_id])
      end
    end
  end

  def down
    remove_column :capsules, :readers
  end
end
