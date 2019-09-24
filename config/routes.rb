Rails.application.routes.draw do
  devise_for :users
  resources :result_sheets, only: [:new, :create, :show, :index, :destroy]
  resources :studies, only: %i[index]
  root 'welcome#index'

end
