class Profile < ApplicationRecord
  has_many :users

  validates_presence_of :title,
                        :description
end
