class AddTenantAssociationToCapsules < ActiveRecord::Migration
  def up
    add_column :capsules, :tenant_id, :integer
    add_index :capsules, :tenant_id

    unless ENV['RAILS_ENV'] == 'test'
      tenant = Tenant.find_or_create_by(name: 'Capsule')
      Capsule.unscoped.update_all tenant_id: tenant.id
    end
  end

  def down
    remove_index :capsules, :tenant_id
    remove_column :capsules, :tenant_id
  end
end
