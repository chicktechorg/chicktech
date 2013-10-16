Chicktech::Application.routes.draw do
  resources :events
  devise_for :users, :controllers => {:registrations => "registrations"}
  #devise_for :users
  resources :users, :only => [:show, :index]
  resources :jobs
  root :to => "static_pages#index"
end
