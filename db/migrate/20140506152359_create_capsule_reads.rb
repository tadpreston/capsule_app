class CreateCapsuleReads < ActiveRecord::Migration
  def change
    create_table :capsule_reads do |t|
      t.references :user, index: true
      t.references :capsule, index: true

      t.timestamps
    end
  end
end
