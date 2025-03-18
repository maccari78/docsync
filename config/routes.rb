Rails.application.routes.draw do
  resources :admin_dashboards
  devise_for :users
  root "home#index"

  resources :appointments
  resources :admin_dashboards
  resources :patients
  resources :clinics
end