Rails.application.routes.draw do
  # root 'welcome#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "api/v1/movies#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      resources :sessions, only: :create
      resources :movies, only: [:index] do
        collection do 
          get 'search'
        end
      end
      resources :viewing_parties, only: [:create, :show, :index] do
        post 'users', to: 'viewing_parties#add_users'
      end
    end
  end
end
