RemindersApi::Application.routes.draw do
  resources :event_lists

  mount ApiDoc::Engine => '/api_docs'
end
