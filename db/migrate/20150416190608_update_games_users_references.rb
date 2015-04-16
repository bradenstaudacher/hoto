class UpdateGamesUsersReferences < ActiveRecord::Migration
  def change
    drop_table(:games_users)
    create_table :games_users do |t|
      t.references :game
      t.references :user
      t.string :colour
      t.integer :previous_rating
    end
  end
end
