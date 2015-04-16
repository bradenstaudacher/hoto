class UpdatePlayersUsers < ActiveRecord::Migration
  def change
    rename_table :players, :users
  end
end
