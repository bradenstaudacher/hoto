class AddJoin < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.references :games
      t.references :players
    end
  end
end
