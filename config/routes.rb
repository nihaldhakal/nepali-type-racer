Rails.application.routes.draw do
  devise_for :users
  get 'type_racers/index'
  root to: "type_racers#index"
  get 'type_racers/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
