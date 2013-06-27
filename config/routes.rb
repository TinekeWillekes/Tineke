Tineke::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
    devise_scope :user do
        root to: "devise/sessions#new"
        end
    devise_for :users
  resources :users
  
  match 'users/activate/:id', :to => 'users#activate', :as => :user
  match 'users/deactivate/:id', :to => 'users#deactivate', :as => :user
    
  match ':controller(/:action(/:id))(.:format)'
end