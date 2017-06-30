Rails.application.routes.draw do
  # External Redirects
  get "books/evasion",      to: redirect("http://evasionbook.com"), status: 301
  get "books/evasion.html", to: redirect("http://evasionbook.com"), status: 301

  # Store Redirect and support page
  get "store",               to: redirect("https://store.crimethinc.com")
  get "store/order-success", to: "about#post_order_success", as: :post_order_success


  # Homepage
  root to: "home#index"



  get "page(/1)", to: redirect { |_, _| "/" }
  get "page/:page", to: "home#index"

  # Articles
  # Article listings by year, optional month, optional day
  get "(/:year)(/:month)(/:day)/page(/1)", to: redirect { |_, req|
    req.path.split("page").first
  }
  get "(/:year)(/:month)(/:day)(/page/:page)",
      to:          "archives#index",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :archives

  # Article permalink
  get ":year/:month/:day/:slug",
      to:          "articles#show",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :article

  # Article edit convenience route
  get ":year/:month/:day/:slug/edit",
      controller: "admin/articles",
      action:     "edit",
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }

  get "archives", to: redirect("/read"), as: :archives_redirect

  # Draft Articles and Pages
  get "drafts/articles/:draft_code", to: "articles#show", as: :article_draft
  get "drafts/pages/:draft_code",    to: "pages#show",    as: :page_draft

  # Draft Articles and Pages /edit convenience routes
  get "drafts/articles/:draft_code/edit", controller: "admin/articles", action: "edit"

  # Articles Atom Feed
  get "feed.json", to: "articles#index", defaults: { format: "json" }, as: :json_feed
  get "feed",      to: "articles#index", defaults: { format: "atom" }, as: :feed

  # Articles - Collection Items
  get "articles/:id/collection_posts", to: "collection_posts#index"


  # Static pages
  get "arts/submission-guidelines", to: "about#arts_submission_guidelines"


  # Categories
  get "categories/:slug/page(/1)",     to: redirect { |path_params, _| "/categories/#{path_params[:slug]}" }
  get "categories/:slug(/page/:page)", to: "categories#show", as: :category
  get "categories/:slug/feed",         to: "categories#feed", defaults: { format: "atom" }, as: :category_feed

  # Tags
  get "tags/:slug/page(/1)",     to: redirect { |path_params, _| "/tags/#{path_params[:slug]}" }
  get "tags/:slug(/page/:page)", to: "tags#show", as: :tag
  get "tags/:slug/feed",         to: "tags#feed", defaults: { format: "atom" }, as: :tag_feed

  # Pages (linked in header/nav)
  get "read",   to: "about#read",        as: :read
  get "watch",  to: redirect("videos"),  as: :watch_redirect
  get "listen", to: redirect("podcast"), as: :listen_redirect
  get "get",    to: redirect("store"),   as: :get_redirect


  # Podcast
  get "podcast/feed",           to: "podcast#feed",       as: :podcast_feed, defaults: { format: "rss" }
  get "podcast",                to: "podcast#index",      as: :podcast
  get "podcast/:id",            to: "podcast#show",       as: :episode
  get "podcast/:id/transcript", to: "podcast#transcript", as: :episode_transcript


  # Books
  get "books/lit-kit",        to: "books#lit_kit",        as: :books_lit_kit
  get "books/into-libraries", to: "books#into_libraries", as: :books_into_libraries
  get "books/:slug/extras",   to: "books#extras",         as: :books_extras
  get "books",                to: "books#index",          as: :books
  get "books/:slug",          to: "books#show",           as: :book


  # Videos
  get "videos/page(/1)", to: redirect { |_, _| "/videos" }
  get "videos",          to: "videos#index", as: :videos
  get "videos/:slug",    to: "videos#show",  as: :video


  # Posters, Stickers, Zines
  get "posters",        to: "posters#index",  as: :posters
  get "posters/:slug",  to: "posters#show",   as: :poster
  get "stickers",       to: "stickers#index", as: :stickers
  get "stickers/:slug", to: "stickers#show",  as: :sticker
  get "zines",          to: "zines#index",    as: :zines
  get "zines/:slug",    to: "zines#show",     as: :zine


  # Tools
  get "tools/downloads", to: redirect("/logos")
  get "tools/logos",     to: redirect("/logos")
  get "tools/stickers",  to: redirect("/stickers")
  get "tools/zines",     to: redirect("/zines")
  get "tools/posters",   to: redirect("/posters")
  get "tools/videos",    to: redirect("/videos")
  get "tools",           to: "tools#index", as: :tools


  # Site search
  get "search", to: "search#index"


  # Email newsletter signup, used on homepage
  resources :subscribers, only: [:create]


  # Admin Dashboard
  get :admin, to: redirect("/admin/articles"), as: "admin"
  namespace :admin do
    concern :paginatable do
      get "page(/1)", on: :collection, to: redirect { |_, req| req.path.split("page").first }
      get "(page/:page)", action: :index, on: :collection, as: ""
    end

    resources :articles, concerns: :paginatable do
      member do
        get "new", as: :new_collection_post
      end
    end

    resources :books,        concerns: :paginatable
    resources :categories,   concerns: :paginatable
    resources :contributors, concerns: :paginatable
    resources :episodes,     concerns: :paginatable
    resources :links,        concerns: :paginatable
    resources :pages,        concerns: :paginatable
    resources :podcasts,     concerns: :paginatable
    resources :posters,      concerns: :paginatable
    resources :redirects,    concerns: :paginatable
    resources :roles,        concerns: :paginatable
    resources :settings,     concerns: :paginatable
    resources :stickers,     concerns: :paginatable
    resources :subscribers,  concerns: :paginatable
    resources :themes,       concerns: :paginatable
    resources :users,        concerns: :paginatable
    resources :videos,       concerns: :paginatable
    resources :zines,        concerns: :paginatable
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
  get "manifest.json",  to: "misc#manifest_json"
  get "opensearch.xml", to: "misc#opensearch_xml"

  # Wordpress admin URL redirects
  get "wp-admin",     to: redirect("/admin")
  get "wp-login.php", to: redirect("/signin")
  get "wp-login.php?action=logout&_wpnonce=:nonce", to: redirect("/signout")

  # Ping and Health monitoring
  mount NewRelicPing::Engine, at: "/status"

  # Pages
  get "*path", to: "pages#show", as: :page, via: :all
end
