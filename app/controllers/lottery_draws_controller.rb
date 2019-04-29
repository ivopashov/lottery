class LotteryDrawsController < ApplicationController
  def create
    lottery_draw = LotteryDraw.generate_for

    redirect_to lottery_draw_path(lottery_draw)
  end

  def show
    @lottery_draw = LotteryDraw.find params[:id]
    @winners = LotteryDrawService.execute(@lottery_draw)
  end
end