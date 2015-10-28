Rails.application.routes.draw do

  resources :cabinet_details

  # USERS
  resources :users

  # COMPANIES
  resources :companies do
    resources :users
  end

  # EVENTS
  resources :events do
    get :autocomplete_event_name, :on => :collection
  end

  match 'welcome' => 'welcome#index', via: :get

  # Routes for authentication
  resources :sessions
  match "login" => 'sessions#new', via: :get
  match "logout" => 'sessions#destroy', via: :get
  match 'signup' => 'companies#new', via: :get

  # Root
  root 'events#index'
end
