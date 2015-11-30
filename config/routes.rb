Rails.application.routes.draw do

  resources :patients

  resources :agendas do
    resources :events
    get :autocomplete_agenda_name_cabinet, on: :collection
    get :show_day_events, on: :member
    get :show_day, on: :member
  end

  resources :cabinet_details

  # USERS
  resources :users do
    resources :agendas do
      get :show_day, on: :member
    end
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

  post "events/incoming", to: 'events#accept_or_reject', as: 'incoming'

  match 'welcome' => 'welcome#index', via: :get

  # Routes for authentication
  resources :sessions
  match "login" => 'sessions#new', via: :get
  match "logout" => 'sessions#destroy', via: :get
  match 'signup' => 'companies#new', via: :get

  # Root
  root 'users#index'
end
