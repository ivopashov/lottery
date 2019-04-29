class CreateLotteryTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :lottery_tickets do |t|
      t.string :name, null: false
      t.references :lottery_draw, foreign_key: true
      t.integer :numbers, array: true, default: [], null: false
      t.timestamps
    end
  end
end
