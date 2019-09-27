Rails.application.routes.draw do
  devise_for :users
  resources :result_sheets, only: %i[new create show index destroy]
  resources :studies, only: %i[index edit update destroy]
  get 'dashboard', to: 'dashboard#index'
  root 'welcome#index'
end
