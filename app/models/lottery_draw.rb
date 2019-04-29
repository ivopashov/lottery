class LotteryDraw < ApplicationRecord
  class << self
    def draw
      LotteryDrawNumber.transaction do
        lottery_draw = create! lottery_draw_numbers: draw_six_numbers
        LotteryTicket.where(lottery_draw: nil) do |eligible_ticket|
          eligible_ticket.update! lottery_draw: lottery_draw
        end
      end

      lottery_draw
    end

    def draw_six_numbers
      (1..49).to_a.shuffle.take(6)
    end
  end
end
