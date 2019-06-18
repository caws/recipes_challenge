FactoryBot.define do
  factory :ingredient do
    measurement { Faker::Food.measurement }
    name { Faker::Food.ingredient }
    recipe factory: :recipe
  end
end
