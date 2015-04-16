class JoinTableUsersGames < ActiveRecord::Migration
  def change
    drop_table(:games_players)
    create_table :games_users do |t|
      t.references :games
      t.references :users
      t.string :colour
      t.integer :previous_rating
    end
  end
end
