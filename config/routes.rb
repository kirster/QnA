Rails.application.routes.draw do
  resources :questions, only: [:new, :create, :show] do
    resources :answers, only: [:new, :create, :show], shallow: true
  end
end
