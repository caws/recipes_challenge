module V1
  module Recipes
    class RecipeRelatedFinder < ApplicationService
      attr_accessor :params, :recipe

      def initialize(params)
        self.params = params
      end

      def call
        self.recipe = Recipe.find_by_id(params[:id])
        recipe.related = recipe.related_recipes.pluck(:id)
        recipe
      end
    end
  end
end