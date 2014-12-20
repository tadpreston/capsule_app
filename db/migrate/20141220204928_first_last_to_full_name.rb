class FirstLastToFullName < ActiveRecord::Migration
  def up
    add_column :users, :full_name, :string

    User.all.each do |user|
      user.update_attribute(:full_name, "#{user.first_name} #{user.last_name}")
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def down
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.all.each do |user|
      name = user.full_name.split(' ')
      user.update_attributes(first_name: name[0], last_name: name[1])
    end

    remove_column :users, :full_name
  end
end
