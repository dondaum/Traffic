Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get "/contact", to: "start#contact"
  get "/help", to: "start#help"
  get 'start/index'
  root 'start#index'
  get 'signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/distance', to: 'distances#new'
  get '/range', to: 'distances#show'
  post '/distance',  to: 'distances#create'
  resources :distances


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
