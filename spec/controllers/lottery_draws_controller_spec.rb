require 'rails_helper'

RSpec.describe LotteryDrawsController, type: :controller do
  describe 'POST create' do
    let(:lottery_draw) { double id: 1 }
    before(:each) { allow(LotteryDraw).to receive(:generate_for).and_return(lottery_draw) }

    it 'creates' do
      expect(LotteryDraw).to receive(:generate_for)

      post :create
    end

    it 'redirects' do
      post :create

      expect(response).to redirect_to(lottery_draw_path(lottery_draw))
    end
  end

  describe 'GET show' do
    let(:lottery_draw) { double id: 1 }
    let(:winners) { double }

    before(:each) do
      allow(LotteryDraw).to receive(:find) { lottery_draw }
      allow(LotteryDrawService).to receive(:execute) { winners }
    end

    it 'finds winning tickets' do
      expect(LotteryDrawService).to receive(:execute).with(lottery_draw)

      get :show, params: {id: 1}
    end

    it 'assigns lottery draw' do
      get :show, params: {id: 1}

      expect(assigns(:lottery_draw)).to eq(lottery_draw)
    end

    it 'assigns winners' do
      get :show, params: {id: 1}

      expect(assigns(:winners)).to eq(winners)
    end
  end
end