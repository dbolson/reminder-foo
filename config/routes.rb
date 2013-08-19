RemindersApi::Application.routes.draw do
  #match '/lists', to: 'pages#lists'
  match '/account', to: 'pages#account'
  match '/sign_in', to: 'pages#sign_in'

  resources :event_lists, only: [:index, :show]
  resources :events, only: [:index, :show]
  mount API::Root => '/api'
  get '/api/documentation', to: 'api_documentation#index'

  #match '/404', to: 'errors#not_found'
  #match '/500', to: 'errors#internal_server_error'
  root to: 'event_lists#index'
end
