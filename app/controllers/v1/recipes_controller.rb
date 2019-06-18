class V1::RecipesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show, :search]
  load_and_authorize_resource except: [:index, :show, :search]
  before_action :set_recipe, only: [:show, :update, :destroy]

  # GET /recipes
  def index
    @recipes = V1::Recipes::RecipeFinder.call(params)

    paginate json: @recipes
  end

  # GET /search
  def search
    @recipes = Recipe.search_recipe(params[:query]).page(params[:page])

    paginate json: @recipes
  end

  # GET /recipes/1
  def show
    if params[:related]
      @recipe = V1::Recipes::RecipeRelatedFinder.call(params)
    end

    unless @recipe
      render json: {}, status: :no_content
      return
    end

    render json: @recipe
  end

  # POST /recipes
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      render json: @recipe.reload, status: :created
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      render json: @recipe.reload
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find_by_id(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def recipe_params
    params.require(:recipe).permit(:name,
                                   :description,
                                   :user_id,
                                   :cooker,
                                   :time_to_prepare,
                                   :image,
                                   :servings,
                                   directions_attributes: [
                                       :id, :step, :description, :_destroy
                                   ],
                                   ingredients_attributes: [
                                       :id, :name, :measurement, :_destroy
                                   ])
  end
end
