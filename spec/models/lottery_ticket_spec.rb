require 'rails_helper'

RSpec.describe LotteryTicket do
  it 'identifies tickets that have not played yet' do
    lottery_draw = create :lottery_draw, numbers: [1, 2, 3, 4, 5, 6]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6], name: 'played already'
    create :lottery_ticket, lottery_draw: nil, numbers: [1, 2, 3, 4, 5, 6], name: 'not played yet'

    tickets_not_played_yet = LotteryTicket.not_played_yet

    expect(tickets_not_played_yet.count).to eq 1
    expect(tickets_not_played_yet.first.name).to eq 'not played yet'
  end
end