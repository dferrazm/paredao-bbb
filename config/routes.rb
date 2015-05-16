ParedaoBbb::Application.routes.draw do
  devise_for :admin_users
  root to: 'votes#index'

  resources :votes, only: [:index, :create] do
    collection do
      get :result
      get :percentage
    end
  end

  namespace :admin do
    root to: 'home#index'
    post '/poll/start', to: 'home#start'
    post '/poll/stop', to: 'home#stop'
    resources :contestants, except: [:show, :edit, :update]
    resources :stats, only: :index do
      collection do
        get :hourly
      end
    end
  end
end
