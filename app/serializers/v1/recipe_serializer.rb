class V1::RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name, :time_to_prepare, :servings, :description, :image
  attribute :related, if: :include_related?

  belongs_to :user

  has_many :ingredients, key: :ingredients_attributes
  has_many :directions, key: :directions_attributes

  def include_related?
    if object.related.nil?
      return false
    end

    true
  end

  def image
    if object.image.url.nil?
      # This would have to be stored somewhere in a database
      return {url: 'https://res.cloudinary.com/caws/image/upload/v1555172600/download.png'}
    end

    object.image
  end
end
