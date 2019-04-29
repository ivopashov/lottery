class CreateLotteryDraws < ActiveRecord::Migration[5.2]
  def change
    create_table :lottery_draws do |t|
      t.timestamps
      t.integer :numbers, array: true, default: [], null: false
    end
  end
end
