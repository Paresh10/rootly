  Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'incidents#index'
  resource :incidents, only: [:index, :show, :create]
  match '/incidents/new',    to: 'incidents#new', via: [:get, :post]
end
