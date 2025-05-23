Rails.application.routes.draw do
  post "signup" => "users#create"
  resources :users, only: %i[ show index update ] do
    get "/posts" => "users#posts"
    get "/followers" => "users#followers"
    get "/following" => "users#following"
  end

  resources :follows

  resources :posts, except: %i[ update ] do
    post "/share" => "posts#share"
    patch "/likes" => "posts#like"
    resources :comments, except: %i[ update ] do
      patch "/likes" => "comments#like"
    end
  end

  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  root "health_checks#health_check"
end
