Rails.application.routes.draw do

  resources :patients

  resources :agendas do
    resources :events
  end

  resources :cabinet_details

  # USERS
  resources :users do
    resources :agendas
  end

  # COMPANIES
  resources :companies do
    resources :users
    resources :agendas
    resources :patients
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
  root 'users#index'
end
