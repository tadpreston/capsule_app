class CreateObjections < ActiveRecord::Migration
  def change
    create_table :objections do |t|
      t.references :objectionable, polymorphic: true, index: true
      t.references :user, index: true
      t.text :comment
      t.boolean :dmca
      t.boolean :criminal
      t.references :admin_user, index: true
      t.datetime :handled_at

      t.timestamps
    end
  end
end
