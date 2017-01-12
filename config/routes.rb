Rails.application.routes.draw do
  # External Redirects
  get "books/evasion",      to: redirect("http://evasionbook.com"), status: 301
  get "books/evasion.html", to: redirect("http://evasionbook.com"), status: 301


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


  # Categories
  get "categories/:slug", to: "categories#show", as: :category


  # Pages (linked in header/nav)
  get "read",   to: "about#read",   as: :read
  get "watch",  to: "about#watch",  as: :watch
  get "listen", to: redirect("podcast"), as: :listen_redirect # TEMP TODO
  # get "listen", to: "about#listen", as: :listen
  get "get",    to: redirect("http://store.crimethinc.com"), as: :get_redirect # TEMP TODO
  # get "buy",    to: "about#buy",    as: :buy


  # Podcast
  get "podcast/feed", to: redirect("http://exworker.libsyn.com/rss"), as: :podcast_feed_redirect # TEMP TODO
  get "podcast/feed", to: "podcast#feed",   as: :podcast_feed
  get "podcast",      to: "podcast#index",  as: :podcast
  get "podcast/:id",  to: "podcast#show",   as: :episode
  get "podcast/:id/transcript",  to: "podcast#transcript", as: :episode_transcript


  # Books
  get "books/lit-kit",           to: "books#lit_kit",         as: :books_lit_kit
  get "books/into-libraries",    to: "books#into_libraries",  as: :books_into_libraries
  get "books",                   to: "books#index",           as: :books
  get "books/:slug",             to: "books#show",            as: :book
  get "books/:slug/extras",      to: "books#extras",          as: :book_extras


  # Site search
  get "search", to: "search#index"


  # Email newsletter signup, used on homepage
  resources :subscribers, only: [:create]


  # Admin Dashboard
  get :admin, to: redirect("/admin/articles"), as: "admin"
  namespace :admin do
    resources :articles
    resources :books
    resources :episodes
    resources :links
    resources :pages
    resources :podcasts
    resources :redirects
    resources :settings
    resources :subscribers
    resources :themes
    resources :users
    resources :videos
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

  # Ping and Health monitoring
  mount NewRelicPing::Engine, at: "/status"

  # Pages
  get "*path", to: "pages#show", as: :page, via: :all
end
