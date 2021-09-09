Rails.application.routes.draw do
  root to: 'home#index'
  get 'task_app', to: 'home#index'

  post 'login', to: 'sessions#create'

  get 'dashboard', to: 'projects#index'
  resources :projects, only: %i[index show]
  resources :customers, only: %i[index show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
