RemindersApi::Application.routes.draw do
  root to: 'event_lists#index'

  resources :event_lists

  mount ApiDoc::Engine => '/api_docs'
end
