Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root :to => "home#index"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :users, except: [:create, :new]
  resources :holidays
  resource :app_settings, except: [:new, :destroy, :create]
  resources :event_types, only: [:index]
  resources :events
  resources :profiles
  resources :identities

  match 'schedule', to: 'schedules#show', via: [:get]
  match 'schedule', to: 'schedules#create', via: [:post]
end
