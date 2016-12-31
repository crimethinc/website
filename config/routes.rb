Rails.application.routes.draw do
  # Homepage
  root to: "home#index"


  # Articles
  # Article permalink
  get ":year/:month/:day/:slug",
      to:          "articles#show",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :article

  # Article listings by year, optional month, optional day
  get "(/:year)(/:month)(/:day)",
      to:          "archives#index",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :archives

  get "archives", to: redirect("/read"), as: :archives_redirect

  # Draft Articles and Pages
  get "drafts/articles/:draft_code", to: "articles#show", as: :article_draft
  get "drafts/pages/:draft_code",    to: "pages#show",    as: :page_draft

  # Articles Atom Feed
  get "feed", to: "articles#index", defaults: { format: "atom" }, as: :feed

  # Pages (linked in header/nav)
  get "read",   to: "about#read",   as: :read
  get "watch",  to: "about#watch",  as: :watch
  get "listen", to: redirect("podcast"), as: :listen_redirect # TEMP TODO
  # get "listen", to: "about#listen", as: :listen
  get "buy",    to: redirect("http://store.crimethinc.com"), as: :buy_redirect # TEMP TODO
  # get "buy",    to: "about#buy",    as: :buy

  # Podcast
  get "podcast/feed", to: redirect("http://exworker.libsyn.com/rss"), as: :podcast_feed_redirect # TEMP TODO
  get "podcast/feed", to: "podcast#feed",   as: :podcast_feed
  get "podcast",      to: "podcast#index",  as: :podcast
  get "podcast/:id",  to: "podcast#show",   as: :episode
  get "podcast/:id/transcript",  to: "podcast#transcript", as: :episode_transcript



  # Email newsletter signup, used on homepage
  resources :subscribers, only: [:create]


  # Admin Dashboard
  get :admin, to: redirect("/admin/articles"), as: "admin"
  namespace :admin do
    resources :users
    resources :articles
    resources :pages
    resources :podcasts
    resources :episodes
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
