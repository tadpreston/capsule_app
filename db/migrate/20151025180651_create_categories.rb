class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    ['Birthday', 'Good Morning', 'Good Night', 'Good Luck', 'Congratulations', 'Love', 'Sorry', 'Happy Thanksgiving', 'Merry Christmas', 'Happy New Year'].each do |name|
      Category.create name: name
    end
  end
end
