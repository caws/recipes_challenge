class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :read, Recipe
      can :most_popular, Ingredient
    elsif user.admin?
      can :manage, :all
    elsif user.cook?
      can :manage, Recipe, user_id: user.id
      can [:create, :show, :update, :destroy], User, id: user.id
    end
  end
end
