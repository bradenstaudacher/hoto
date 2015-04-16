class AddRelationship < ActiveRecord::Migration
  def change
    add_reference :squares, :game, index: true
  end
end
