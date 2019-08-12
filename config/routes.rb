Rails.application.routes.draw do
  resources :invoices

  namespace :invoice do
    resources :bulk_uploads
  end

  root to: 'invoice/bulk_uploads#new'
end