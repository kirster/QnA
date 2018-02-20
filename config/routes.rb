Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :create_vote
      delete :delete_vote
    end
   end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], only: [:create, :destroy, :update], shallow: true do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  
end
