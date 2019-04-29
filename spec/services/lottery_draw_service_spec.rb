require 'rails_helper'

RSpec.describe LotteryDrawService do
  let(:lottery_draw) { create :lottery_draw, numbers: [1, 2, 3, 4, 5, 6] }
  it 'ignores tickets with common numbers below threshold' do
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [7, 8, 9, 10, 11, 12]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [6, 7, 8, 9, 10, 11]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [5, 6, 7, 8, 9, 10]

    winning_tickets = LotteryDrawService.execute lottery_draw

    expect(winning_tickets.size).to eq 0
  end

  it 'correctly identifies winning tickets with at least 3 lucky numbers' do
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 10, 11, 12]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 10, 11]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 10]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6]

    winning_tickets = LotteryDrawService.execute lottery_draw

    expect(winning_tickets.size).to eq 4
    expect(winning_tickets.map(&:common_numbers)).to eq [3, 4, 5, 6]
  end

  it 'calculates prizes for jackpot ticket when non jackpot tickets also present' do
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 10, 11, 12]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6]

    jackpot_ticket =
      LotteryDrawService.
      execute(lottery_draw).
      select { |ticket| ticket.common_numbers == 6 }.
      first

    expect(jackpot_ticket.amount).to eq 500
  end

  it 'calculates prizes for jackpot tickets when only jackpot tickets present' do
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6]

    jackpot_ticket =
      LotteryDrawService.
        execute(lottery_draw).
        select { |ticket| ticket.common_numbers == 6 }.
        first

    expect(jackpot_ticket.amount).to eq 1000
  end

  it 'distributes prizes fairly' do
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 10, 11, 12]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 10, 11]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 10]
    create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6]

    winning_tickets = LotteryDrawService.execute(lottery_draw)

    expect(winning_tickets.map(&:amount)).to eq [100, 150, 250, 500]
  end

  it 'splits prizes among equal groups' do
    2.times do
      create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 10, 11, 12]
      create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 10, 11]
      create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 10]
      create :lottery_ticket, lottery_draw: lottery_draw, numbers: [1, 2, 3, 4, 5, 6]
    end

    winning_tickets =
      LotteryDrawService.
        execute(lottery_draw).
        sort { |ticket_one, ticket_two| ticket_one.amount <=> ticket_two.amount }

    expect(winning_tickets.map(&:amount)).to eq [50, 50, 75, 75, 125, 125, 250, 250]
  end
end