Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

match '/contact_forms/new',     to: 'contact_forms#new',             via: 'get'
resources "contact_forms", only: [:new, :create]
  root to: "home#index"

  resource :user, only: [:show]

  resources :grants do
    member do
      get 'preview'
    end
    resources :payments, except: [:index]
  end

end
