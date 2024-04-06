Rails.application.routes.draw do
  resources :uploads, except: :new
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "healthcheck" => "rails/health#show", as: :rails_health_check
  mount GoodJob::Engine => '/admin/jobs'


  # Defines the root path route ("/")
  root "uploads#index"
end
