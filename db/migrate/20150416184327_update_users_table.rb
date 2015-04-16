class UpdateUsersTable < ActiveRecord::Migration
  def change
    add_column(:users, :password, :string)
    add_column(:users, :email, :string)
    add_column(:users, :current_rating, :integer)
    remove_column(:users, :colour)
  end
end
