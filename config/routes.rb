Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :users
  resources :event_types, only: [:index]
  resources :events
  resources :profiles
  resources :identities

  match 'schedule/:year/:month', to: 'schedules#show', via: [:get], as: 'schedules'
  match 'schedule', to: 'schedules#create', via: [:post], as: 'create_schedule'
end
