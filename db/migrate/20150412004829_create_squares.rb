class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.integer :x
      t.integer :y
      t.string :colour
      t.integer :height
      t.timestamps
    end
  end
end
