Rails.application.routes.draw do
  devise_for :users
  mount Commontator::Engine => '/commontator'
  namespace :admin do
    resources :videos do
      resources :subtitles
      member do
        patch :encode
      end
    end
    resources :categories
    resources :photos do
      collection do
        get :featured
      end
    end
  end

  resources :categories, only: [:show] do
    member do
      get :tag
    end

    resources :videos, only: [:index]
  end

  resources :videos, only: [:show, :index] do
    collection do
      get :search
      get :most_viewed
      get :most_scored
      get :most_voted
    end
    member do
      get :download
      get :tag
      get :wide
      get :embed
      put "like", to: "videos#upvote"
      put "dislike", to: "videos#downvote"
      post :favorite
      post :unfavorite
      post :capture_photo
    end
  end

  resources :favorites, only: [:index]

  resources :subtitles do
    member do
      get :tag
      post :add_to_playlist
      post :remove_from_playlist
    end
  end

  resources :playlists
  resources :plays
  resources :photos do
    member do
      get :tag
    end
    collection do
      get :search
    end
  end
  
  get '/admin', to: 'admin/videos#index', as: 'admin_root'
  root to: "videos#index"
end
