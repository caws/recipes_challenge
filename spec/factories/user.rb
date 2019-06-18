FactoryBot.define do
  factory :user do

    name { Faker::Name.name }
    email { "#{Faker::Name.unique.first_name}@somecook.com" }
    password { "123456" }
    profile factory: :profile

  end
end
