class GamesUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  class << self
    def create_assoc_white(game_id, player_id)
      Game.find(game_id).users << User.find(player_id)
      join = GamesUser.where(game_id: game_id).where(user_id: player_id)[0]
      join.colour = 'white'
      join.save
    end

    def create_assoc_black(game_id, player_id)
      Game.find(game_id).users << User.find(player_id)
      join = GamesUser.where(game_id: game_id).where(user_id: player_id)[0]
      join.colour = 'black'
      join.save
    end
  end

end