module V1
  module Ingredients
    class PopularIngredients < ApplicationService

      attr_accessor :ingredients, :number

      def initialize(params)
        self.ingredients = Ingredient.group(:name).count.to_a
        self.number = params[:number].to_i
      end

      def call
        sort_ingredients
        compose_json[0..number - 1]
      end

      def sort_ingredients
        ingredients.sort_by! {|hit_count| hit_count[1]}.reverse!
      end

      def compose_json
        ingredients
            .map! {|x| {ingredient_name: x[0], recipes_that_have_this_ingredient: x[1]}}
            .to_a
      end

    end
  end
end