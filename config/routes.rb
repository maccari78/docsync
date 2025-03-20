Rails.application.routes.draw do
  devise_for :users

  resources :clinics
  resources :professionals
  resources :patients
  resources :secretaries
  resources :appointments
  resources :admin_dashboards, only: [:index]

  root "appointments#index"
end