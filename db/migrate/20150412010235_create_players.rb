class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :colour
      t.integer :games_played
      t.integer :games_won
      t.timestamps
    end
  end
end
