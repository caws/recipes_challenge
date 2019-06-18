# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "Creating profiles"

Profile.find_or_create_by(title: 'ADMINISTRATOR',
                          description: 'The system administrator.')

Profile.find_or_create_by(title: 'COOK',
                          description: 'The individual who\'s going to upload recipes.')

puts 'Creating admin user'

User.create(name: 'Admin',
            email: 'admin@admin.com',
            profile: Profile.first,
            password: '123123123',
            password_confirmation: '123123123')

User.create(name: 'Great Cook',
            email: 'great@cook.com',
            profile: Profile.second,
            password: '123',
            password_confirmation: '123')

User.create(name: 'Great Cook2',
            email: 'great2@cook.com',
            profile: Profile.second,
            password: '123',
            password_confirmation: '123')

puts 'Creating recipes for Great Cook'

# direction0 = Direction.new(step: 1,
#                            description: 'Boil 340ml of water')
#
# direction1 = Direction.new(step: 2,
#                            description: 'Add lamen to the boiling water')
#
# direction2 = Direction.new(step: 3,
#                            description: 'Add seasoning')
#
# ingredient0 = Ingredient.new(portion_and_name: 'One pre-cooked lamen')
# ingredient1 = Ingredient.new(portion_and_name: 'Seasoning')
#
# new_recipe = Recipe.create(user: User.second,
#                            name: 'Regular Lamen',
#                            servings: 1,
#                            time_to_prepare: 50,
#                            description: 'This is not the food you want, but it\'s the food that\'s going to put you through college.',
#                            ingredients: [ingredient0, ingredient1],
#                            directions: [direction0, direction1, direction2])

0.upto(50) do
  FactoryBot.create(:recipe, user: User.last)
end

# puts new_recipe.errors.messages