FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@testemail.com"
  end
end
