class GamesUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  class << self

    def update_elos(game_id)
      binding.pry
      winner = User.find(Game.find(game_id).winner_id)
      loser = User.find(Game.find(game_id).loser_id)

      w_games_played = winner.games_played
      l_games_played = loser.games_played
      
      winner_old_elo = GamesUser.where(game_id: game_id, user_id: winner.id)[0].previous_rating
      loser_old_elo = GamesUser.where(game_id: game_id, user_id: loser.id)[0].previous_rating
      
      
      elo_diff_winner = winner_old_elo - loser_old_elo
      elo_diff_loser = loser_old_elo - winner_old_elo
      expected_outcome_winner = calculate_expected_outcome(elo_diff_winner)
      expected_outcome_loser = calculate_expected_outcome(elo_diff_loser)
      
      case
        when w_games_played > 20
          k_factor_winner = 20
        when (10..19).include?(w_games_played)
          k_factor_winner = 30
        when (0..9).include?(w_games_played)
          k_factor_winner = 40
      end

      case
        when l_games_played > 20
          k_factor_loser = 20
        when (10..19).include?(l_games_played)
          k_factor_loser = 30
        when (0..9).include?(l_games_played)
          k_factor_loser = 40
      end
      
      binding.pry
      
      elo_adjustment_winner = k_factor_winner * ( 1 - expected_outcome_winner )
      elo_adjustment_loser = k_factor_loser * ( 0 - expected_outcome_loser )

      winner.current_rating += elo_adjustment_winner
      winner.save
        
      loser.current_rating += elo_adjustment_loser
      loser.save

    end

    def calculate_expected_outcome(elo_diff_for_self)
      case
      when elo_diff_for_self < -800
        return 0.0
      when (-799..-677).include?(elo_diff_for_self)
        return 0.01
      when (-676..-366).include?(elo_diff_for_self)
        return 0.1
      when (-365..-240).include?(elo_diff_for_self)
        return 0.2
      when (-239..-149).include?(elo_diff_for_self)
        return 0.3
      when (-148..-72).include?(elo_diff_for_self)
        return 0.4
      when (-71..71).include?(elo_diff_for_self)
        return 0.5
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
      join.previous_rating = User.find(player_id).current_rating
      join.save
    end

    def create_assoc_black(game_id, player_id)
      Game.find(game_id).users << User.find(player_id)
      join = GamesUser.where(game_id: game_id).where(user_id: player_id)[0]
      join.colour = 'black'
      join.previous_rating = User.find(player_id).current_rating
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

    def get_colour_by_id(game_id, player_id)
      return GamesUser.where(game_id: game_id).where(user_id: player_id)[0].colour
    end
  end

end