class EloChangeTable < ActiveRecord::Migration
  def change
    create_table :elo_changes do |t|
      t.references :user
      t.integer :change
      t.timestamps
    end
  end
end
