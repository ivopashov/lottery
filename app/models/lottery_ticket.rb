class LotteryTicket < ApplicationRecord
  belongs_to :lottery_draw, optional: true

  class << self
    def not_played_yet
      where lottery_draw: nil
    end
  end
end
