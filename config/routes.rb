Rails.application.routes.draw do
  resources :result_sheets, only: [:new, :create, :show]
end
