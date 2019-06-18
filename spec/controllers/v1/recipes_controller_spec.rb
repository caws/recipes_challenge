require 'rails_helper'
require 'support/controllers_helper'

RSpec.configure do |c|
  c.include ControllerHelpers
end

RSpec.describe V1::RecipesController do
  let!(:admin) {FactoryBot.create(:user, profile: Profile.first)}
  let!(:authentication) {authenticate_user(admin.email, admin.password)}
  let!(:add_authentication_to_request_header) {request.headers.merge!(authentication)}

  describe 'GET #index' do
    let(:valid_keys) {JSON.parse(V1::RecipeSerializer.new(FactoryBot.create(:recipe)).to_json).keys}

    context 'when a user_id is not present' do
      let!(:index) {get :index}
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'first item of JSON response contains expected recipe attributes' do
        first_item_of_json_response = JSON.parse(response.body)[0]

        expect(first_item_of_json_response.keys).to match_array(valid_keys)
      end
    end

    context 'when a user_id is present' do
      let!(:user) {FactoryBot.create(:user)}
      let!(:recipe) {FactoryBot.create(:recipe, user: user)}
      let!(:index) {get :index, params: {user_id: user.id} }
      let!(:serialized_recipe) {V1::RecipeSerializer.new(recipe).as_json}

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'first item of JSON response contains recipe attributes of the first recipe of a given user' do
        first_item_of_json_response = JSON.parse(response.body)[0]

        expect(first_item_of_json_response['id']).to match(serialized_recipe.as_json['id'])
      end

    end
  end

  describe 'GET #show' do
    context 'for a recipe that is present' do
      let(:recipe) {FactoryBot.create(:recipe)}

      context 'without the ids of related recipes' do
        let!(:show) {get :show, params: {id: recipe.id}}

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns recipe' do
          recipe_id_returned = JSON.parse(response.body)['id']
          expect(recipe_id_returned).to match(recipe.id)
        end
      end

      context 'with the ids of related recipes' do
        let!(:show) {get :show, params: {id: recipe.id, related: true}}
        let(:keys) {%w[id name time_to_prepare servings description image related user ingredients_attributes directions_attributes]}

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns recipe with attribute holding ids of related recipes' do
          expect(JSON.parse(response.body).keys).to match(keys)
        end
      end

    end


    context 'for recipe that is not present' do
      let!(:show) {get :show, params: {id: Recipe.last.id + 1}}

      it 'returns http not found' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_user) {FactoryBot.create(:user)}
    let(:valid_recipe) {FactoryBot.build(:recipe, user: valid_user)}
    let(:valid_params) {V1::RecipeSerializer.new(valid_recipe).as_json}
    let!(:adequate_params) {valid_params[:user_id] = valid_params[:user][:id]}

    context 'with valid parameters' do
      let!(:create) {post :create, params: {recipe: valid_params}}

      it 'creates a new recipe' do
        expect(Recipe.last.name).to match(valid_recipe.name)
      end

      it 'returns http created' do
        expect(response).to have_http_status :created
      end
    end

    context 'with invalid parameters' do

      describe 'with missing directions' do
        let(:missing_directions) {valid_params.except(:directions_attributes)}
        let!(:create) {post :create, params: {recipe: missing_directions}}

        it 'does not create a recipe' do
          expect {:create}.to change {Recipe.count}.by(0)
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns json with validation error message for directions' do
          expect(JSON.parse(response.body).keys).to match(%w[directions])
        end
      end

      describe 'with missing user' do
        let(:missing_user_params) {valid_params.except(:user_id)}
        let!(:create) {post :create, params: {recipe: missing_user_params}}

        it 'does not create a recipe' do
          expect {:create}.to change {Recipe.count}.by(0)
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns json with validation error message for user' do
          expect(JSON.parse(response.body).keys).to match(%w[user])
        end
      end

      describe 'with missing name' do
        let(:missing_name_params) {valid_params.except(:name)}
        let!(:create) {post :create, params: {recipe: missing_name_params}}

        it 'does not create a recipe' do
          expect {:create}.to change {Recipe.count}.by(0)
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns json with validation error message for name' do
          expect(JSON.parse(response.body).keys).to match(%w[name])
        end
      end

      describe 'with missing time to prepare' do
        let(:missing_ttp_params) {valid_params.except(:time_to_prepare)}
        let!(:create) {post :create, params: {recipe: missing_ttp_params}}

        it 'does not create a recipe' do
          expect {:create}.to change {Recipe.count}.by(0)
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns json with validation error message for time to prepare' do
          expect(JSON.parse(response.body).keys).to match(%w[time_to_prepare])
        end
      end

      describe 'with missing description' do
        let(:missing_description_params) {valid_params.except(:description)}
        let!(:create) {post :create, params: {recipe: missing_description_params}}

        it 'does not create a recipe' do
          expect {:create}.to change {Recipe.count}.by(0)
        end

        it 'returns http unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns json with validation error message for description' do
          expect(JSON.parse(response.body).keys).to match(%w[description])
        end
      end

      describe 'with missing directions attributes' do
        describe 'with missing step' do
          let(:missing_step_params) {valid_params}
          let!(:remove_step) {missing_step_params[:directions_attributes][0]['step'] = ''}
          let!(:create) {post :create, params: {recipe: missing_step_params}}

          it 'does not create a recipe' do
            expect {:create}.to change {Recipe.count}.by(0)
          end

          it 'returns http unprocessable entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns json with validation error message for directions.step' do
            expect(JSON.parse(response.body).keys).to match(%w[directions.step])
          end
        end

        describe 'with missing description' do
          let(:missing_description_params) {valid_params}
          let!(:remove_description) {missing_description_params[:directions_attributes][0]['description'] = ''}
          let!(:create) {post :create, params: {recipe: missing_description_params}}

          it 'does not create a recipe' do
            expect {:create}.to change {Recipe.count}.by(0)
          end

          it 'returns http unprocessable entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns json with validation error message for directions.description' do
            expect(JSON.parse(response.body).keys).to match(%w[directions.description])
          end
        end
      end

      describe 'with missing ingredients attributes' do
        describe 'with missing ingredient name' do
          let(:missing_ingredient_name) {valid_params}
          let!(:remove_ingredient_name) {missing_ingredient_name[:ingredients_attributes][0]['name'] = ''}
          let!(:create) {post :create, params: {recipe: missing_ingredient_name}}

          it 'does not create a recipe' do
            expect {:create}.to change {Recipe.count}.by(0)
          end

          it 'returns http unprocessable entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns json with validation error message for ingredients.name' do
            expect(JSON.parse(response.body).keys).to match(%w[ingredients.name])
          end
        end

        describe 'with missing ingredient measurement' do
          let(:missing_ingredient_measurement) {valid_params}
          let!(:remove_ingredient_name) {missing_ingredient_measurement[:ingredients_attributes][0]['measurement'] = ''}
          let!(:create) {post :create, params: {recipe: missing_ingredient_measurement}}

          it 'does not create a recipe' do
            expect {:create}.to change {Recipe.count}.by(0)
          end

          it 'returns http unprocessable entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns json with validation error message for ingredients.measurement' do
            expect(JSON.parse(response.body).keys).to match(%w[ingredients.measurement])
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user1) {FactoryBot.create(:user, profile: Profile.second)}
    let(:user2) {FactoryBot.create(:user, profile: Profile.second)}
    let(:user1_recipe) {FactoryBot.create(:recipe, user: user1)}
    let(:user2_recipe) {FactoryBot.create(:recipe, user: user2)}
    let(:authenticate_cook) {authenticate_user(user1.email, user1.password)}
    let!(:add_to_request_header_cook) {request.headers.merge!(authenticate_cook)}

    describe 'one user updates their own recipe' do
      let(:update_params) {V1::RecipeSerializer.new(user1_recipe).as_json}
      let!(:change_description) {update_params[:description] = 'Some different description'}
      let!(:update) {patch :update, params: {id: user1_recipe.id, recipe: update_params}}

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json with updated field' do
        expect(JSON.parse(response.body)['description']).to match('Some different description')
      end
    end

    describe 'one user updates other user\'s recipe' do
      let(:update_params) {V1::RecipeSerializer.new(user2_recipe).as_json}
      let!(:change_description) {update_params[:description] = 'Some different description'}
      let!(:change_user) {update_params[:user_id] = user1.id}
      let!(:update) {patch :update, params: {id: user2_recipe.id, recipe: update_params}}

      it 'returns http not authorized' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end