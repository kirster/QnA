Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: [:create, :destroy, :update], shallow: true
  end
end
