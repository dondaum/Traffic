Rails.application.routes.draw do
  get 'users/new'

  get "/contact", to: "start#contact"

  get "/help", to: "start#help"

  get 'start/index'

  root 'start#index'

  get 'signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
