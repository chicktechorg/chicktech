Chicktech::Application.routes.draw do
  resources :events
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit_password' => 'devise/registrations#edit', :as => 'change_password'
      put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
    end
  resources :users
  resources :jobs do
    resources :tasks
  end
  resources :tasks
  resources :cities, :except => [:new, :edit, :update]
  resources :teams
  resources :leadership_roles, :only => :update
  resources :comments
  root :to => "static_pages#index"
end
