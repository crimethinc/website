Rails.application.routes.draw do
  # Homepage
  root to: "archives#home"


  # Archives
  get "archives", to: "archives#index", as: :archives
  get "archive",  to: redirect("/archives")


  # Articles
  # Article permalink
  get ":year/:month/:day/:slug",
      to:          "articles#show",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :article

  # Article listings by year, optional month, optional day
  get "(/:year)(/:month)(/:day)",
      to:          "articles#index",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :articles

  # Draft Articles and Pages
  get "drafts/articles/:draft_code", to: "articles#show", as: :article_draft
  get "drafts/pages/:draft_code",    to: "pages#show",    as: :page_draft

  # Articles Atom Feed
  get "feed", to: "articles#index", defaults: { format: "atom" }, as: :feed


  # Email newsletter signup
  resources :subscribers, only: [:create]


  # Admin Dashboard
  get :admin, to: redirect("/admin/articles"), as: "admin"
  namespace :admin do
    resources :users
    resources :articles
    resources :pages
    resources :links
    resources :redirects
    resources :settings
    resources :subscribers
    resources :themes
  end


  # Auth + User signup
  namespace :auth do
    resources :users,    only: [:create, :update, :destroy]
    resources :sessions, only: [:create]
  end

  get "profile",  to: "auth/users#show",       as: :profile
  get "settings", to: "auth/users#edit",       as: :settings
  get "signup",   to: "auth/users#new",        as: :signup
  get "signin",   to: "auth/sessions#new",     as: :signin
  get "signout",  to: "auth/sessions#destroy", as: :signout


  # Pages
  get "read",   to: "about#read",   as: :read
  get "watch",  to: "about#watch",  as: :watch
  get "listen", to: "about#listen", as: :listen


  # Misc plumbing infrastructure
  get "manifest.json",  to: "misc#mainfest_json"
  get "opensearch.xml", to: "misc#opensearch_xml"

  # Wordpress admin URL redirects
  get "wp-admin.php", to: redirect("/admin")
  get "wp-login.php", to: redirect("/signin")
  get "wp-login.php?action=logout&_wpnonce=:nonce", to: redirect("/signout")

  # Redirects
  get "store", to: redirect("http://store.crimethinc.com")


  # Pages
  get "*path", to: "pages#show", as: :page, via: :all
end
