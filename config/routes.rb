Rails.application.routes.draw do
  resources :profiles
  resources :resources

  resources :projects do
    resources :adjustments, except: [:show, :index]
  end

  resources :clients
  resources :calendar_days, only: :index
  resources :reports, only: :index
  resources :events, only: %i[index new create]

  resources :users, only: [], shallow: true do
    resources :calendar, only: :index, controller: 'users/calendar'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :admin do
    resources :users
  end

  root to: 'visitors#index'
end
