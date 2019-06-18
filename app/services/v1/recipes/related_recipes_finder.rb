module V1
  module Recipes
    class RelatedRecipesFinder < ApplicationService
      attr_accessor :recipe

      def initialize(recipe)
        self.recipe = recipe
      end

      def call
        if recipe.ingredients.present?
          Recipe.query_related_recipes(recipe.id, ingredient_terms)
        end
      end

      def ingredient_terms
        names = ingredient_names
        names.map {|name| name == names.last ? name.to_s : "#{name}|"}
            .join(" ")
      end

      def ingredient_names
        recipe.ingredients.pluck(:name)
      end
    end
  end
end