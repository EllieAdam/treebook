Rails.application.routes.draw do
  get 'profiles/:id' => 'profiles#show', as: 'profiles'

  devise_for :users

  devise_scope :user do
    get "register", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
  end

  resources :statuses
  root 'statuses#index'
end
