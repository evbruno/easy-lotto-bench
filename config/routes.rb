Rails.application.routes.draw do
  resources :draws
  resources :games
  resources :lotteries

  root to: 'lotteries#index'

  namespace :benchmarks do
    get 'task1'
    get 'task2'
  end

end
