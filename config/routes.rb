Rails.application.routes.draw do
  # Public Site
  root to: 'articles#index'
  resources :articles


  # Admin Dashboard
  get 'admin', to: redirect('/admin/users'), as: 'admin'
  namespace :admin do
    resources :users
  end


  # Users + Auth
  namespace :auth do
    resources :users,    only: [:create, :update, :destroy]
    resources :sessions, only: [:create]
  end

  get 'profile',  to: 'auth/users#show',       as: 'profile'
  get 'settings', to: 'auth/users#edit',       as: 'settings'
  get 'signup',   to: 'auth/users#new',        as: 'signup'
  get 'signin',   to: 'auth/sessions#new',     as: 'signin'
  get 'signout',  to: 'auth/sessions#destroy', as: 'signout'

  # Wordpress admin URL redirects
  get 'wp-admin.php', to: redirect('/admin')
  get 'wp-login.php', to: redirect('/signin')
  get 'wp-login.php?action=logout&_wpnonce=:nonce', to: redirect('/signout')
end
