require "sidekiq/web"

Rails.application.routes.draw do
  root to: redirect("/discounts")

  scope module: "dashboard" do
    resources :discounts, only: %i[index new create] do
      namespace :code do
        resources :batches, only: %i[new create]
        get '/codes', to: 'batches#index', as: 'codes'
        get '/batches/download', to: 'batches#download', as: "download"
        resources :duplicates, only: :create
      end
    end
  end

  mount Sidekiq::Web => "/sidekiq" # Sidekiq portal
end
