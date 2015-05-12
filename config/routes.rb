ParedaoBbb::Application.routes.draw do
  devise_for :admins
  root to: 'votes#index'

  resources :votes, only: [:index, :create] do
    collection do
      get :result
      get :percentage
    end
  end

  namespace :admin do
    root to: 'home#index'
    resources :contestants, except: [:show, :edit, :update]
    resources :stats, only: :index do
      collection do
        get :hourly
      end
    end
  end
end
