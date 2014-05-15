class MakeCommentsPolymorphic < ActiveRecord::Migration
  def up
    drop_table :comments

    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, polymorphic: true, index: true
      t.text       :body
      t.hstore     :likes_store

      t.timestamps
    end
  end

  def down
    say 'This migration is not reversible'
  end
end
