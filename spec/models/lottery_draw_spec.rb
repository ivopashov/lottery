require 'rails_helper'

RSpec.describe LotteryDraw do
  it 'generates a lottery draw' do
    expect{LotteryDraw.generate_for}.to change{LotteryDraw.count}.by(1)
  end

  it 'assigns tickets that have not played yet to a lottery draw' do
    create :lottery_ticket, lottery_draw: nil, numbers: [1, 2, 3, 4, 5, 6], name: 'not played yet'

    LotteryDraw.generate_for

    expect(LotteryTicket.first.lottery_draw).not_to be_nil
  end
end