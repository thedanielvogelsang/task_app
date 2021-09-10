Rails.application.routes.draw do
  get 'task_logs/create'
  root to: 'home#index'
  get 'task_app', to: 'home#index'

  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'dashboard', to: 'projects#index'
  resources :projects, only: %i[index show new update destroy] do
    resources :tasks, only: %i[new show]
  end
  resources :tasks, only: %i[update destroy]
  resources :customers, only: %i[index show new update destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :task_logs, only: %i[create]
end
