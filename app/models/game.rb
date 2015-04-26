class Game < ActiveRecord::Base
  has_many :squares
  has_and_belongs_to_many :users

  attr_accessor :_turn

  def turn
    if self._turn.nil?
      self._turn = Turn.new(self.turnstate)
    end
    self._turn
  end

  def get_name_from_winner_id
    return User.find(winner_id).name if !active
  end

    def get_square_from_coord(coord)
      Square.where(x: coord[0]).where(y: coord[1]).where(game_id: id)[0]
    end
  
    def switch_turnstate
       if self.turnstate == "white"
        self.turnstate = "black"
        self.save
      else
        self.turnstate = "white"
        self.save
      end
      self.phase = 'place'
      self.save
    end

    def any_valid_moves?
      # if place is done && the user only has squares that are 1 high
      users_squares = self.squares.where(colour: turnstate)
      users_squares_that_are_high_enough = users_squares.select {|square| square.height > 1 }
      squares_heights = users_squares.map { |square| square.height }
      unless squares_heights.include?(2) || squares_heights.include?(3)
       return false
      end

      arr = []
       users_squares_that_are_high_enough.each do |square|
          # adj_coords  = square.all_squares_adjacent_to
          # adj_squares = adj_coords.map {|coords| get_square_from_coord(coords)}
          # adj_squares.reject! {|square| square.empty?}
          # arr = adj_squares.select { |squarey| squarey.occupied? }

          arr2 = square.all_empty_squares_adjacent_to
          arr2.flatten!
          arr << arr2
          arr.flatten!
        end
        if arr.empty?
          return false
        end
        true
    end

    def any_valid_topples?
      # to-do   remove the repition in the any_valid methods
      self.any_valid_moves?

       users_squares = self.squares.where(colour: turnstate)
      users_squares_that_are_high_enough = users_squares.select {|square| square.height > 1 }
      squares_heights = users_squares.map { |square| square.height }

         if phase == 'topple'
          binding.pry
       
        end
      
    end


    def update_active
# to-do  refactor to remove repetition
      if moves_counter > 2
         black_id = GamesUser.where(colour: 'black', game_id: id)[0].user_id
          white_id = GamesUser.where(colour: 'white', game_id: id)[0].user_id
        if !(squares.each.map { |square| square.colour }.include?("black"))
          self.update(active: false)
          self.update(winner_id: white_id)
          self.update(loser_id: black_id)
          winner = User.find(white_id)
          loser = User.find(black_id)
          winner.games_won += 1 
          winner.games_played += 1
          loser.games_played += 1
          winner.save
          loser.save
        elsif !(squares.each.map { |square| square.colour }.include?("white"))
          self.update(winner_id: black_id)
          self.update(loser_id: white_id)
          self.update(active: false)
          winner = User.find(black_id)
          loser = User.find(white_id)
          winner.games_won += 1 
          winner.games_played += 1
          loser.games_played += 1
          winner.save
          loser.save
        end
      end
    end


  class << self 
    def board id
      board = []
      # Square.all.each do |square|
      #   board << square
      # end
      # board

      row1 = []
      row2 = []
      row3 = []
      row4 = []
      row5 = []

      squares = Square.where(game_id: id)
      squares.each do |square, index|
        if row1.length < 5
          row1 << square
        elsif row2.length < 5
          row2 << square
        elsif row3.length < 5
          row3 << square
        elsif row4.length < 5
          row4 << square
        else 
          row5 << square
        end
      end
      board << row1 << row2 << row3 << row4 << row5
    end

    def make_squares(game_id)
      counter = 1
      while counter <= 5
        i = 1
        while i <= 5
          puts "i done did make a square!!"
          Square.create(x: i, y: counter, height: 0, game_id: game_id, colour: 'empty')
          i += 1
        end
        counter += 1
      end
    end


  end
end
