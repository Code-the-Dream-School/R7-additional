Rails.application.routes.draw do
  resources :orders
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
root to: 'customers#index'
  # Defines the root path route ("/")
  # root "articles#index"
end
