FactoryGirl.define do
  factory :tenant do
    name 'Test Tenant'

    after(:create) do |tenant, evaluater|
      create(:tenant_key, tenant: tenant, name: 'iOS')
    end
  end
end
