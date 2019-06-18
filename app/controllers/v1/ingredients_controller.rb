class V1::IngredientsController < ApplicationController
  skip_before_action :authenticate_request, only: [:most_popular]
  load_and_authorize_resource

  # GET /most_popular
  def most_popular
    @ingredients = V1::Ingredients::PopularIngredients.call(ingredient_params)

    render json: @ingredients
  end

  private

  # Only allow a trusted parameter "white list" through.
  def ingredient_params
    params.permit(:number)
  end

end
