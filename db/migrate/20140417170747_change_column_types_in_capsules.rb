class ChangeColumnTypesInCapsules < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :capsules do |t|
        dir.up do
          t.remove :payload_type
          t.remove :promotional_state
          t.integer :payload_type
          t.integer :promotional_state
        end

        dir.down do
          t.remove :payload_type
          t.remove :promotional_state
          t.string :payload_type
          t.string :promotional_state
        end
      end
    end
  end
end
