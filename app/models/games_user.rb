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

    def sort_player(session_id, params_id)
      @gameuser = GamesUser.where(user_id: session_id).where(game_id: params_id)[0]
      if session_id
        if @gameuser
        return @current_colour = @gameuser.colour
      elsif Game.find(params_id).users.length < 2
        create_assoc_black(Game.find(params_id), session_id)
        return @current_colour = @gameuser.colour
      end
        return @current_colour = "viewer"
      else
        return @current_colour = "anonymous viewer"
      end
    end
  end

end