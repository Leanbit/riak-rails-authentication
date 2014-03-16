RiakRailsAuthentication::Application.routes.draw do
  
  root :to => 'sessions#new'
  resources :users
  resources :sessions, :only => [:new, :create] do
    delete 'destroy', :on => :collection
  end

end
