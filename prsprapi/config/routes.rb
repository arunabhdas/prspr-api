Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # get 'home/index'
  root 'home#index'
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    namespace :v1, defaults: { format: :json } do
        resources :properties
        resources :addresses
        resource :sessions, only: [:create, :destroy]
        
        post   "/sign-in"       => "sessions#create"
        delete "/sign-out"      => "sessions#destroy"
    end


end
