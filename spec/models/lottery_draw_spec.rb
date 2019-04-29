require 'rails_helper'

RSpec.describe LotteryDraw do
  it 'draws six numbers' do
    expect(LotteryDraw.draw_six_numbers.size).to eq 6
  end

  it 'draws numbers within a range' do
    numbers = LotteryDraw.draw_six_numbers

    numbers.each { |number| expect(number).to be_between(1, 49) }
  end

  it 'draws six unique numbers' do
    expect(LotteryDraw.draw_six_numbers.uniq.size).to eq 6
  end
end