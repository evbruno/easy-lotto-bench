class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.integer :hits
      t.float :value
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
