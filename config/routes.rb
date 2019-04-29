Rails.application.routes.draw do
  root 'lottery_tickets#index'

  resources :lottery_tickets, only: %i(new create index)
  resources :lottery_draws, only: %i(create show)
end
