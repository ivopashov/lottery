require 'rails_helper'

RSpec.describe LotteryTicketsController, type: :controller do
  describe 'GET index' do
    it 'gets all tickets that have not played yet' do
      expect(LotteryTicket).to receive(:not_played_yet)

      get :index
    end

    it 'assigns tickets' do
      tickets = double
      allow(LotteryTicket).to receive(:not_played_yet).and_return(tickets)

      get :index

      expect(assigns(:lottery_tickets)).to eq(tickets)
    end
  end

  describe 'GET new' do
    it 'instantiates' do
      expect(LotteryTicket).to receive(:new)

      get :new
    end

    it 'assigns instance' do
      ticket = double
      allow(LotteryTicket).to receive(:new).and_return(ticket)

      get :new

      expect(assigns(:lottery_ticket)).to eq(ticket)
    end
  end

  describe 'POST create' do
    let(:params) { {lottery_ticket: {name: 'name', numbers: '1,2,3'}} }

    it 'creates' do
      expect(LotteryTicket).to receive(:create)

      post :create, params: params
    end

    it 'redirects' do
      post :create, params: params

      expect(response).to redirect_to(lottery_tickets_path)
    end

    it 'maps parameters correctly' do
      expect(LotteryTicket).to receive(:create).with(name: 'name', numbers: [1, 2, 3])

      post :create, params: params
    end
  end
end
