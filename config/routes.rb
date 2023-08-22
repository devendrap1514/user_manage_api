Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "/login", to: "users#login"
  post "/signup", to: "users#signup"
  get "/users/profile", to: "users#profile"
  get "/logout", to: "users#logout"
  patch "/users/update", to: "users#update"
  get "/users", to: "users#index"
end
