class V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  # belongs_to :profile

  # has_many :recipes
end
