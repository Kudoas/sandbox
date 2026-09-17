Rails.application.routes.draw do
  root "notes#index"
  resources :notes
  get "up" => "rails/health#show", as: :rails_health_check
end
