Rails.application.routes.draw do
  resources :houses do
	  resources :steps, only: [:show, :update], controller: 'steps_controllers/house_steps'
	end
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
