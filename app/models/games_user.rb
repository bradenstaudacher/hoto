class GamesUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  class << self

    def update_elos(game_id, player_id)
      # winner = Game.find(game_id).winner_id
      # opponent_id = GamesUser.where(game_id: game_id).select {|gamerecord| gamerecord.user_id != player_id}[0].user_id
      # old_own_elo = GamesUser.where(game_id: game_id, user_id: id)[0].previous_rating
      # old_opponent_elo = GamesUser.where(game_id: game_id).select {|gamerecord| gamerecord.user_id != player_id}[0].previous_rating
      # current_own = User.find(player_id)
      # current_opponent = User.find(opponent_id)
      # elo_diff_for_self = old_own_elo - old_opponent_elo
      # expected_outcome = calculate_expected_outcome(elo_diff_for_self)
      # k_factor = 40

      # if player_id == winner
      #   elo_adjustment_self = k_factor * ( 1 – expected_outcome )
      #   elo_adjustment_opponent = -elo_adjustment_self

      #   current_own.current_rating += elo_adjustment_self
      #   current_own.save
        
      #   current_opponent.current_rating += elo_adjustment_opponent
      #   current_opponent.save
      # else
      #   elo_adjustment_self = k_factor * ( 0 – expected_outcome )
      #   elo_adjustment_opponent = -elo_adjustment_self

      #   current_own.current_rating += elo_adjustment_self
      #   current_own.save

      #   current_opponent.current_rating += elo_adjustment_opponent
      #   current_opponent.save
      # end
      
    end

    def calculate_expected_outcome(elo_diff_for_self)
      case
      when elo_diff_for_self < -800
        return 0.0
      when (-677..-799).include?(elo_diff_for_self)
        return 0.01
      when (-366..-676).include?(elo_diff_for_self)
        return 0.0
      when (-240..-365).include?(elo_diff_for_self)
        return 0.0
      when (-149..-239).include?(elo_diff_for_self)
        return 0.0
      when (-72..-148).include?(elo_diff_for_self)
        return 0.0
      when (-71..71).include?(elo_diff_for_self)
        return 0.0
      when elo_diff_for_self > 800
        return 1.0
      when (677..799).include?(elo_diff_for_self)
        return 0.99
      when (366..676).include?(elo_diff_for_self)
        return 0.9
      when (240..365).include?(elo_diff_for_self)
        return 0.8
      when (149..239).include?(elo_diff_for_self)
        return 0.7
      when (72..148).include?(elo_diff_for_self)
        return 0.6
      end
    end

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

    def set_player_colour(session_id, params_id)
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