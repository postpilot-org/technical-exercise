require "sidekiq/web"

Rails.application.routes.draw do
  root to: redirect("/discounts")

  scope module: "dashboard", path: "" do
    resources :discounts, only: %i[index new create] do
      namespace :code do
        resources :batches, only: %i[new create]
        resources :duplicates, only: :create
      end
      member do
        post :export_codes
      end
    end

    get "downloads/:key", to: "downloads#show", as: :download, constraints: { key: /.+/ }
  end

  mount Sidekiq::Web => "/sidekiq" # Sidekiq portal
end