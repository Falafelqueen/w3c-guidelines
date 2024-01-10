Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "guidelines#index"

  resources :guidelines, only: [:index]

  get "components", to: "pages#test", as: "test"
  get "about", to: "pages#about"
end
