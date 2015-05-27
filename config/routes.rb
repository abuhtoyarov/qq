Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do
    post '/confirm_email' => 'omniauth_callbacks#confirm_email'
  end

  root to: "questions#index"

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, :on, :collection
      end
    end
  end

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:create] do
      patch 'accept', on: :member
    end
    resources :comments, only: [:create], defaults: { commentable: 'questions' }
  end

  resources :answers, except: [:create], concerns: [:votable] do
    resources :comments, only: [:create], defaults: { commentable: 'answers' }
  end

  resources :comments, only: [:update, :destroy]

end
