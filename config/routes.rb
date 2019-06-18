Rails.application.routes.draw do
  # AṔI
  concern :api do
    post :authenticate, to: :authenticate, controller: :authentication
    post :signup, to: :signup, controller: :signup

    scope :ingredients do
      get :most_popular, to: :most_popular, controller: :ingredients
    end

    scope :recipes do
      get :search, to: :search, controller: :recipes
    end
    resources :recipes

    resources :users do
      resources :recipes
    end

    resources :profiles do
      resources :users
    end
  end

  namespace :v1 do
    concerns :api
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
