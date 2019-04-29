class LotteryDrawService
  PRIZE = 1000
  THREE_COMMON_NUMBERS = 3
  FOUR_COMMON_NUMBERS = 4
  FIVE_COMMON_NUMBERS = 5
  JACKPOT_COMMON_NUMBERS = 6
  THREE_COMMON_NUMBERS_PRIZE_SHARE = 0.1
  FOUR_COMMON_NUMBERS_PRIZE_SHARE = 0.15
  FIVE_COMMON_NUMBERS_PRIZE_SHARE = 0.25
  COMMON_NUMBERS_THRESHOLD = THREE_COMMON_NUMBERS
  WinningTicket = Struct.new :amount, :numbers, :name, :common_numbers

  class << self
    def execute(lottery_draw)
      new(lottery_draw).execute
    end
  end

  def initialize(lottery_draw)
    @lottery_draw = lottery_draw

    @non_jackpot_distributions = {
      THREE_COMMON_NUMBERS => THREE_COMMON_NUMBERS_PRIZE_SHARE,
      FOUR_COMMON_NUMBERS => FOUR_COMMON_NUMBERS_PRIZE_SHARE,
      FIVE_COMMON_NUMBERS => FIVE_COMMON_NUMBERS_PRIZE_SHARE
    }
  end

  def execute
    find_winning_tickets
    distribute_prize
    @winning_tickets
  end

  private

  def find_winning_tickets
    @winning_tickets =
      LotteryTicket.where(lottery_draw: @lottery_draw).
        select { |ticket| (ticket.numbers & @lottery_draw.numbers).size >= COMMON_NUMBERS_THRESHOLD }.
        map { |ticket| WinningTicket.new 0, ticket.numbers, ticket.name, (ticket.numbers & @lottery_draw.numbers).size }

    @jackpot_tickets = @winning_tickets.select { |ticket| ticket.common_numbers == JACKPOT_COMMON_NUMBERS }
  end

  def distribute_prize
    @non_jackpot_distributions.each do |common_numbers, share|
      tickets = @winning_tickets.select { |ticket| ticket.common_numbers == common_numbers }
      tickets.each { |ticket| ticket.amount = (PRIZE * share) / tickets.size  }
    end

    distribute_prize_for_jackpot_tickets
  end

  def distribute_prize_for_jackpot_tickets
    @jackpot_tickets.each { |ticket| ticket.amount = jackpot_prize / @jackpot_tickets.size }
  end

  def jackpot_prize
    non_jackpot_tickets_count =
      @winning_tickets.
      select { |ticket| ticket.common_numbers != JACKPOT_COMMON_NUMBERS }.
      size

    share = non_jackpot_tickets_count.zero? ? 1 : 0.5

    PRIZE * share
  end
end
