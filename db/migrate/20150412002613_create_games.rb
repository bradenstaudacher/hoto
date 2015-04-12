class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :turnstate
      t.timestamps
    end
  end
end
