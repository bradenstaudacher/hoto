class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|

      t.timestamps
    end
  end
end
