Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: "home#index"

  get "/user/:user_id", to: "users#show"

  resources :grants

end
