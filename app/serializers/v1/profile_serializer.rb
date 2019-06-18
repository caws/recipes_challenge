class V1::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :users
end
