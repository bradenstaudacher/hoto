class EloAddTrackerAndDefault < ActiveRecord::Migration
  def change
    change_column :users, :current_rating, :integer, :default => 1000
  end
end
