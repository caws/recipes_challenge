FactoryBot.define do
  factory :recipe do

    name {Faker::Food.dish}
    time_to_prepare {rand(1..50)}
    servings {rand(1..10)}
    description {Faker::Food.description}
    user factory: :user

    before :create do |recipe|
      recipe.ingredients << FactoryBot.build_list(:ingredient, rand(1..10), recipe: nil)
      recipe.directions << FactoryBot.build_list(:direction, rand(1..10), recipe: nil)
    end

    after :build do |recipe|
      recipe.ingredients << FactoryBot.build_list(:ingredient, rand(1..10), recipe: nil)
      recipe.directions << FactoryBot.build_list(:direction, rand(1..10), recipe: nil)
    end

  end
end
