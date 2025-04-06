Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # /rewards and /rewards/:id endpoints
      resources :rewards, only: [:index, :show] do
        member do
          # /rewards/:id/redeem endpoint
          post :redeem
        end
      end

      # /users/:id/balance and /users/:id/redemptions endpoints
      resources :users, only: [] do
        member do
          # GET /users/:id/balance
          get :balance
          # GET /users/:id/redemptions
          resources :redemptions, only: [:index, :create], shallow: true
        end
      end
    end
  end

  # Root route to serve the React frontend
  root 'application#index'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
