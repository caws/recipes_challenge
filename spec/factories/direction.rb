FactoryBot.define do
  factory :direction do
    step {rand(10)}
    description {Faker::Movies::Hobbit.quote}
    recipe factory: :recipe
  end
end
