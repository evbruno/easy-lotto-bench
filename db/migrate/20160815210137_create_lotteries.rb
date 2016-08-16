class CreateLotteries < ActiveRecord::Migration
  def change
    create_table :lotteries do |t|
      t.string :name
      t.string :abbrev
      t.string :source_url

      t.timestamps null: false
    end
  end
end
