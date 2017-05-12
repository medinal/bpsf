Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get "/user/:user_id", to: "users#show"
match '/contact_forms/new',     to: 'contact_forms#new',             via: 'get'
resources "contact_forms", only: [:new, :create]
  root to: "home#index"


  resources :grants do
    member do
      get 'preview'
    end
  end

end
