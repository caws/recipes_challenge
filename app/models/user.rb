class User < ApplicationRecord
  has_secure_password

  belongs_to :profile
  has_many :recipes, dependent: :nullify

  validates_uniqueness_of :email

  validates_presence_of :name, :email, :password_digest

  validates :email, length: {maximum: 255},
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}

  accepts_nested_attributes_for :recipes, allow_destroy: true

  def admin?
    V1::Profiles::ProfileChecker.call(self, :administrator)
  end

  def cook?
    V1::Profiles::ProfileChecker.call(self, :cook)
  end

  # Users who sign up are always going to be cooks
  def self.new_cook(params)
    V1::Users::CookCreator.call(params)
  end
end
