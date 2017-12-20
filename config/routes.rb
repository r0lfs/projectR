Rails.application.routes.draw do
 
	devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post "/check_username", to: "users/registrations#check_username"
    post "/check_email", to: "users/registrations#check_email"
  end

  resources :user_ratings
  
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
