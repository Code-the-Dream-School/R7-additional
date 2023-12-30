Rails.application.routes.draw do
  root to: "customers#index"
  resources :customers
  # Define a resource for orders with CRUD actions
  resources :orders
  
  delete "/customers/customerAndOrders/:id", to: "customers#destroy_with_orders"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
