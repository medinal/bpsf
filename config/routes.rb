Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  match '/contact_forms/new',     to: 'contact_forms#new',             via: 'get'
  resources "contact_forms", only: [:new, :create]
  root to: "home#index"

  resource :user, only: [:show] do
    resource :profiles, path: "profile", except: [:index, :show, :delete]
  end

  get '/user/grants' => 'grants#usergrants', as: 'user_grants'

  resources :grants do
    resources :payments, except: [:index]
  end

end
