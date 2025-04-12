Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  post "/users/auth/google_oauth2", to: "users/auth#google_oauth2"

  get '/run_seeds', to: 'seed#run'  

  resources :clinics
  resources :professionals
  resources :patients
  resources :secretaries
  resources :appointments do
    collection do
      get 'json', to: 'appointments#json'
      get 'deleted', to: 'appointments#deleted'
      get 'list', to: 'appointments#list'
    end
    member do
      post 'restore', to: 'appointments#restore'
      delete 'hard_destroy', to: 'appointments#hard_destroy'
      post 'initiate_payment', to: 'appointments#initiate_payment'
      get 'success', to: 'appointments#success'
      get 'failure', to: 'appointments#failure'
    end
  end
  post '/stripe/webhook', to: 'appointments#payment_notification'

  resources :admin_dashboards, only: [:index]

  root "appointments#index"
end