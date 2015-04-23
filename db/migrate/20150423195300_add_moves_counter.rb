class AddMovesCounter < ActiveRecord::Migration
  def change
    add_column(:games, :moves_counter, :integer)
  end
end
