class AddDefaultValues < ActiveRecord::Migration
  def change
    change_column :games, :active, :boolean, :default => true
    change_column :games, :moves_counter, :integer, :default => 0

    change_column :users, :current_rating, :integer, :default => 1200
    change_column :users, :games_played, :integer, :default => 0
    change_column :users, :games_won, :integer, :default => 0

  end
end
