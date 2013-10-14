Chicktech::Application.routes.draw do
  devise_for :users
  resources :users 
  root :to => "static_pages#index"
end


