Rails.application.routes.draw do
  root to: 'articles#index'

  # Admin Dashboard
  namespace :admin do
  end

  # Users + Auth
  resources :users,    only: [:create, :update, :destroy]
  resources :sessions, only: [:create]

  get 'profile',  to: 'users#show',       as: 'profile'
  get 'settings', to: 'users#edit',       as: 'settings'
  get 'signup',   to: 'users#new',        as: 'signup'
  get 'signin',   to: 'sessions#new',     as: 'signin'
  get 'signout',  to: 'sessions#destroy', as: 'signout'

  # Wordpress admin URL redirects
  get 'wp-login.php', to: redirect('/signin')
  get 'wp-login.php?action=logout&_wpnonce=:nonce', to: redirect('/signout')


  # Public Site
  resources :articles
end
