class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :draw_date
      t.references :lottery, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
