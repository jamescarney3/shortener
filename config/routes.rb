Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :short_urls, only: [:create, :destroy]
  end
  
  get '/:slug', to: 'hub#redirect', as: 'hub_redirect'
end
