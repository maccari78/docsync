Rails.application.routes.draw do
  get 'static_pages/about'
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

  resources :medical_supplies do
    member do
      post :add_stock
      post :remove_stock
    end
  end

  resources :conversations, only: [:show] do
    resources :messages, only: [:create]
  end 

  post '/stripe/webhook', to: 'appointments#payment_notification'

  get '/debug/appointments', to: 'debug#appointments'

  get 'about', to: 'static_pages#about'

  resources :admin_dashboards, only: [:index]

  root "appointments#index"
end