class LotteryTicket < ApplicationRecord
  belongs_to :lottery_draw, optional: true

  validate :validate_numbers_in_range, :validate_numbers_are_six

  def validate_numbers_in_range
    if numbers.any? { |number| !number.in? (1..49) }
      errors.add(:numbers, 'Numbers should be between 1 and 49')
    end
  end

  def validate_numbers_are_six
    if numbers.size != 6
      errors.add(:numbers, 'Numbers should be exactly 6')
    end
  end

  class << self
    def not_played_yet
      where lottery_draw: nil
    end
  end
end
