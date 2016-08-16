Rails.application.routes.draw do
  resources :draws
  resources :games
  resources :lotteries

  root to: 'lotteries#index'

  get '/fake' => 'lotteries#fake', as: 'fake', defaults: {format: :json}

end
