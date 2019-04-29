class LotteryDraw < ApplicationRecord
  class << self
    def generate_for
      ActiveRecord::Base.transaction do
        lottery_draw = create!(numbers: draw_six_numbers)
        LotteryTicket.where(lottery_draw: nil).update lottery_draw_id: lottery_draw.id
        lottery_draw
      end
    end

    private

    def draw_six_numbers
      (1..49).to_a.shuffle.take(6)
    end
  end
end
