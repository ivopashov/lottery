class LotteryTicketsController < ApplicationController
  def index
    @lottery_tickets = LotteryTicket.not_played_yet
  end

  def new
    @lottery_ticket = LotteryTicket.new
  end

  def create
    LotteryTicket.create lottery_ticket_params

    redirect_to lottery_tickets_path
  end

  private

  def lottery_ticket_params
    permitted_params = params.require(:lottery_ticket).permit(:name, :numbers).to_h.with_indifferent_access
    {name: permitted_params[:name], numbers: permitted_params[:numbers].split(',').map(&:strip).map(&:to_i)}
  end
end
