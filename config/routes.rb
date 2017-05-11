Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get "/user/:user_id", to: "users#show"

  root to: "home#index"


  resources :grants do
    member do
      get 'preview'
    end
  end

end
