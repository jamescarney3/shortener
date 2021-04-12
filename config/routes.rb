Rails.application.routes.draw do
  get '/:slug', to: 'hub#redirect', as: 'hub_redirect'
end
