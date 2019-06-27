Rails.application.routes.draw do
  # Store Redirect and support page
  get 'store/order-success', to: 'pages#post_order_success', as: :post_order_success
  get 'store', to: redirect('https://store.crimethinc.com')

  # Homepage
  root to: 'home#index'

  get 'page(/1)', to: redirect { |_, _| '/' }
  get 'page/:page', to: 'home#index'

  # To Change Everything (TCE)
  get 'tce(/:lang)',
      to: 'to_change_everything#show',
      defaults: { lang: 'english' },
      as: :to_change_everything

  # Steal Something from Work Day (SSfWD)
  get 'steal-something-from-work-day(/:locale)',
      to: 'steal_something_from_work_day#show',
      defaults: { locale: 'english' },
      as: :steal_something_from_work_day

  # Articles
  # Article listings by year, optional month, optional day
  get '(/:year)(/:month)(/:day)/page(/1)', to: redirect { |_, req|
    req.path.split('page').first
  }
  get '/(:year)/(:month)/(:day)/(page/:page)',
      to:          'article_archives#index',
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :article_archives

  # Article permalink
  get ':year/:month/:day/:slug',
      to:          'articles#show',
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ },
      as:          :article

  # Article edit convenience route
  get ':year/:month/:day/:slug/edit',
      controller: 'admin/articles',
      action:     'edit',
      constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }

  # Draft Articles and Pages
  get 'drafts/articles/:draft_code', to: 'articles#show', as: :article_draft
  get 'drafts/pages/:draft_code',    to: 'pages#show',    as: :page_draft

  # Draft Articles and Pages /edit convenience routes
  get 'drafts/articles/:draft_code/edit', controller: 'admin/articles', action: 'edit'

  # Articles Atom Feed
  get 'feed.json', to: 'articles#index', defaults: { format: 'json' }, as: :json_feed
  get 'feed',      to: 'articles#index', defaults: { format: 'atom' }, as: :feed

  # Articles - Collection Items
  get 'articles/:id/collection_posts', to: 'collection_posts#index'

  # Static pages
  get 'library',                       to: 'pages#library', as: :library
  get 'submission-guidelines',         to: 'pages#submission_guidelines'

  # Categories
  get 'categories',                    to: 'categories#index', as: :categories
  get 'categories/:slug/page(/1)',     to: redirect { |path_params, _| "/categories/#{path_params[:slug]}" }
  get 'categories/:slug(/page/:page)', to: 'categories#show', as: :category
  get 'categories/:slug/feed',         to: 'categories#feed', defaults: { format: 'atom' }, as: :category_feed

  # Tags
  get 'tags/:slug/page(/1)',     to: redirect { |path_params, _| "/tags/#{path_params[:slug]}" }
  get 'tags/:slug(/page/:page)', to: 'tags#show', as: :tag
  get 'tags/:slug/feed',         to: 'tags#feed', defaults: { format: 'atom' }, as: :tag_feed

  # Podcast
  get 'podcast/feed',                                       to: 'podcast#feed',        as: :podcast_feed, defaults: { format: 'rss' }
  get 'podcasts',                                           to: 'podcast#index',       as: :podcasts
  get 'podcasts/:slug',                                     to: 'podcast#show',        as: :podcast
  get 'podcasts/:slug/episodes',                            to: redirect { |path_params, _| "/podcasts/#{path_params[:slug]}" }
  get 'podcasts/:slug/episodes/:episode_number',            to: 'episodes#show',       as: :episode
  get 'podcasts/:slug/episodes/:episode_number/transcript', to: 'episodes#transcript', as: :episode_transcript

  # Books
  get 'books/lit-kit',        to: 'books#lit_kit',        as: :books_lit_kit
  get 'books/into-libraries', to: 'books#into_libraries', as: :books_into_libraries
  get 'books/:slug/extras',   to: 'books#extras',         as: :books_extras
  get 'books',                to: 'books#index',          as: :books
  get 'books/:slug',          to: 'books#show',           as: :book

  # Videos
  get 'videos/page(/1)', to: redirect { |_, _| '/videos' }
  get 'videos',          to: 'videos#index', as: :videos
  get 'videos/:slug',    to: 'videos#show',  as: :video

  # Tools: Posters, Stickers, Zines, Journals, Logos, Music
  get 'posters',        to: 'posters#index',  as: :posters
  get 'posters/:slug',  to: 'posters#show',   as: :poster
  get 'stickers',       to: 'stickers#index', as: :stickers
  get 'stickers/:slug', to: 'stickers#show',  as: :sticker
  get 'journals',       to: 'journals#index', as: :journals
  get 'journals/:slug', to: 'journals#show',  as: :journal
  get 'logos',          to: 'logos#index',    as: :logos
  get 'logos/:slug',    to: 'logos#show',     as: :logo
  get 'zines',          to: 'zines#index',    as: :zines
  get 'zines/:slug',    to: 'zines#show',     as: :zine
  get 'music',          to: 'music#index',    as: :music

  # Tools
  get 'tools', to: 'tools#about', as: :tools

  # Site search
  get 'search',           to: 'search#index'
  get 'search/advanced',  to: 'search#advanced', as: :advanced_search
  post 'search/advanced', to: 'search#advanced_search', as: :advanced_searches

  # Support
  get  'support', to: 'support#new',    as: :support
  post 'support', to: 'support#create', as: :support_create
  get  'thanks',  to: 'support#thanks', as: :thanks

  post 'support/create_session', to: 'support#create_session', as: :support_request
  get  'support/edit/:token',    to: 'support#edit',           as: :support_edit

  post 'support/cancel/:token/:subscription_id', to: 'support#cancel_subscription', as: :support_cancel_subscription
  post 'support/update/:token/:subscription_id', to: 'support#update_subscription', as: :support_update_subscription

  post 'support/stripe_subscription_payment_succeeded_webhook', to: 'support#stripe_subscription_payment_succeeded_webhook'

  # Admin Dashboard
  get :admin, to: redirect('/admin/dashboard'), as: 'admin'
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'markdown',  to: 'dashboard#markdown', as: :markdown

    concern :paginatable do
      get 'page(/1)', on: :collection, to: redirect { |_, req| req.path.split('page').first }
      get '(page/:page)', action: :index, on: :collection, as: ''
    end

    resources :articles, concerns: :paginatable do
      member do
        get 'new', as: :new_collection_post
      end
    end

    resources :books,      concerns: :paginatable
    resources :categories, concerns: :paginatable
    resources :episodes,   concerns: :paginatable
    resources :links,      concerns: :paginatable
    resources :locales,    concerns: :paginatable
    resources :journals,   concerns: :paginatable
    resources :logos,      concerns: :paginatable
    resources :pages,      concerns: :paginatable
    resources :podcasts,   concerns: :paginatable
    resources :posters,    concerns: :paginatable
    resources :redirects,  concerns: :paginatable
    resources :stickers,   concerns: :paginatable
    resources :users,      concerns: :paginatable
    resources :videos,     concerns: :paginatable
    resources :zines,      concerns: :paginatable
  end

  # Auth + User signup
  namespace :auth do
    resources :users,    only: %i[create update destroy]
    resources :sessions, only: [:create]
  end

  get 'settings', to: 'auth/users#edit',       as: :settings
  get 'signin',   to: 'auth/sessions#new',     as: :signin
  get 'signout',  to: 'auth/sessions#destroy', as: :signout

  # Misc plumbing infrastructure
  get 'manifest.json',  to: 'misc#manifest_json'
  get 'opensearch.xml', to: 'misc#opensearch_xml'

  # Pages
  get '/faq', to: 'pages#show', as: :faq, via: :all
  get '/about', to: 'pages#show', as: :about, via: :all
  get '/start', to: 'pages#show', as: :start, via: :all
  get '/contact', to: 'pages#show', as: :contact, via: :all

  # For redirection
  get '*path', to: 'pages#show', as: :page, via: :all
end
