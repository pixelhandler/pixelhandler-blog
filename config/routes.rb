Rails.application.routes.draw do
  # Homepage (recent posts with search support)
  root 'blog/posts#index'

  # Posts
  get '/posts', to: 'blog/posts#index', as: :posts
  get '/posts/:slug', to: 'blog/posts#show', as: :post

  # Tags
  get '/tags', to: 'blog/tags#index', as: :tags
  get '/tag/:slug', to: 'blog/tags#show', as: :tag

  # Authors
  get '/authors/:slug', to: 'blog/authors#show', as: :author

  # About page
  get '/about', to: 'blog/pages#about', as: :about

  # RSS feed
  get '/feed', to: 'blog/feeds#show', as: :feed, defaults: {format: 'xml'}

  # Sitemap
  get '/sitemap.xml', to: 'blog/sitemaps#show', as: :sitemap, defaults: {format: 'xml'}

  # Health check for Railway deployment
  get 'up' => 'rails/health#show', as: :rails_health_check
end
