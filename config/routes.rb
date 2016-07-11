Rails.application.routes.draw do

  post 'authenticate', to: 'authentication#authenticate'
  resources :users
  resources :cabs do
    member do
      patch :activate
    end
  end
  resources :rides ,only:[:index,:create]do
    member do
      put :cancel
      put :complete
    end
  end
end
