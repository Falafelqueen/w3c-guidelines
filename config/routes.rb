Rails.application.routes.draw do
  get 'pages/test'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "guidelines#index"

  resources :guidelines, only: [:index]

  get "components", to: "pages#test"
end
