Rails.application.routes.draw do
  get "static/top"
  root "static#top"

  resources :users, only: [:new, :create]
  get  "signup", to: "users#new"

  resource  :session, only: [:new, :create, :destroy]
  get  "login",  to: "sessions#new"
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
  
end
