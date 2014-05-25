Rails.application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :users
  resources :event_types
  resources :events
  resources :profiles
  resources :identities
end
