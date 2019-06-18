class Recipe < ApplicationRecord
  mount_base64_uploader :image, ImageUploader

  attr_accessor :related

  belongs_to :user

  has_many :ingredients, dependent: :delete_all
  has_many :directions, -> {order(:step)}, dependent: :delete_all

  validates_presence_of :ingredients,
                        :directions,
                        :user,
                        :name,
                        :servings,
                        :time_to_prepare,
                        :description

  validates_numericality_of :time_to_prepare,
                            :servings

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :directions, allow_destroy: true

  scope :query_related_recipes, -> (original_id, ingredients) {
    joins(:ingredients)
        .where('recipes.id != ?', original_id)
        .where("ingredients.name SIMILAR TO ?", "%(#{ingredients})%")
        .limit(10)
  }

  scope :search_recipe, -> (term) {
    joins(:ingredients)
        .joins(:directions)
        .where('LOWER(recipes.name) LIKE ?' \
               'or LOWER(recipes.description) LIKE ?' \
               'or LOWER(ingredients.name) LIKE ?' \
               'or LOWER(directions.description) LIKE ?',
               "%#{term.downcase}%",
               "%#{term.downcase}%",
               "%#{term.downcase}%",
               "%#{term.downcase}%")
        .distinct
  }

  def related_recipes
    V1::Recipes::RelatedRecipesFinder.call(self)
  end
end
