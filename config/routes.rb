Rails.application.routes.draw do
  resources :orders
  resources :customers

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #root "customers#index"
  #get customers_path
  get '/customers', to: 'customers#index'

end
