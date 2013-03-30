RemindersApi::Application.routes.draw do
  root to: 'event_lists#index'

  resources :event_lists

  match '/404', to: 'errors#not_found'

  mount ApiDoc::Engine => '/api_docs'
end
