Rails.application.routes.draw do
  get 'race_templates/new'
  devise_for :users
  get 'type_races/index'
  post 'type_races/create_or_join', to: 'type_races#create_or_join'
  put 'type_races/fetch_progress/:id', to:'type_races#fetch_progress'
  root to: "type_races#index"
  get 'type_races/:id', to: 'type_races#show', as: 'type_race'
  # post 'type_races/create'
  put 'type_races/update_progress/:id', to: 'type_races#update_progress'
  resources :race_templates
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
