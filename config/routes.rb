Rails.application.routes.draw do
  get "static/top"
  root "static#top"

  resources :users, only: [:new, :create]
  get  "signup", to: "users#new"

  get  "login",  to: "sessions#new"
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :posts, only: [:index, :new, :create, :show, :destroy, :edit, :update] do
    resource :like, only: [:create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  
end
