class CreateTenantKeys < ActiveRecord::Migration
  def change
    create_table :tenant_keys do |t|
      t.references :tenant, index: true
      t.string :name
      t.string :token

      t.timestamps
    end

    add_index :tenant_keys, :token
  end
end
