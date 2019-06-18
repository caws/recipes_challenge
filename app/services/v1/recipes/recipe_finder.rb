module V1
  module Recipes
    class RecipeFinder < ApplicationService
      attr_accessor :params

      def initialize(params)
        self.params = params
      end

      def call
        if params[:user_id]
          return User.find_by_id(params[:user_id]).recipes.page(params[:page])
        end

        Recipe.page(params[:page])
      end
    end
  end
end