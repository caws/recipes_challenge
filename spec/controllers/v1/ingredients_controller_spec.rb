require 'rails_helper'
require 'support/controllers_helper'

RSpec.describe V1::IngredientsController do
  let!(:some_user) {FactoryBot.build(:user)}
  describe 'GET #most_popular' do
    describe 'with number of results as a parameter' do
      let(:number_of_results) {rand(1..10)}
      let!(:most_popular) {get :most_popular, params: {
          number: number_of_results
      }
      }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns values in descending order' do
        expect(JSON.parse(response.body).map {|x| x['recipes_that_have_this_ingredient']})
            .to match(JSON.parse(response.body).map {|x| x['recipes_that_have_this_ingredient']}
                          .sort.reverse)
      end
    end
  end
end