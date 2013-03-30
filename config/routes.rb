RemindersApi::Application.routes.draw do
  resources :event_lists, only: [:index, :show, :update, :create, :destroy]

  match '/404', to: 'errors#not_found'

  mount ApiDoc::Engine => '/api_docs'
end
