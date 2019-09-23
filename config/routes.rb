Rails.application.routes.draw do
  devise_for :users
  resources :result_sheets, only: [:new, :create, :show, :index, :destroy]
  root 'welcome#index'

end
