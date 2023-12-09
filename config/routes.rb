Rails.application.routes.draw do
  root to: "customers#index"
  resources :customers
  # Define a resource for orders with CRUD actions
  resources :orders
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
