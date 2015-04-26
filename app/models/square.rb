class Square < ActiveRecord::Base
  belongs_to :game


  def place(player_colour, turn)
    if ((player_colour == colour) || (colour == "empty")) && game.phase == 'place'
      
      self.height += 1
      self.colour = player_colour
      self.save

      game.update(phase: 'topple')
      bloom_counter = 0

      if self.bloomable?
        bloom_counter += 1 
        self.bloom(turn)
        game.switch_turnstate
      end

      if !game.any_valid_moves? && bloom_counter == 0
        game.switch_turnstate
      end
      # returns true because it's been placed. for game controller
      game.moves_counter += 1
      game.save

      turn.place(self)

      return true
    end
    false
  end
  
  def occupied?
    height > 0
  end

  def bloom(turn)
    square_colour = colour
    update(height: 0)
    update(colour: 'empty')
    bloom = turn.bloom(self)
    all_squares_adjacent_to.each do |coord|
      if !Square.offboard?(coord)
        square = game.get_square_from_coord(coord)
        square.height += 1
        square.colour = square_colour
        bloom.adjacent_squares << Action.square_to_coords(square)
        square.save
        if square.bloomable?
          square.bloom(turn)
        end
      end
    end
  end

  def bloomable?
    height == 4
  end

  LEFT = [-1, 0]
  RIGHT = [1, 0]
  UP = [0, -1]
  DOWN = [0, 1]
  ALLDIR = [LEFT, RIGHT, UP, DOWN]


  def topple(direction, turn)
    return false unless valid_move([x + direction[0], y + direction[1]])
    bloom_counter = 0
    square_colour = colour
    num_squares_affected = height
    update(height: 0)
    update(colour: 'empty')
    topple = turn.topple(self)
    coords_affected = []
    counter = 1
    while counter <= num_squares_affected
      coords_affected << [x + direction[0] * counter, y + direction[1] * counter]
      counter += 1 
    end
    coords_affected.select! do |coord|
      !Square.offboard?(coord)
    end
    coords_affected.each do |coord|
      square = game.get_square_from_coord(coord)
      square.height += 1
      square.colour = square_colour
      square.save
      topple.destination_coords << Action.square_to_coords(square)
      if square.bloomable?
        bloom_counter += 1
        square.bloom(turn)
      end
    end
    game.switch_turnstate if bloom_counter > 0 || !game.any_valid_moves? 

    true
  end

  def adj(direction)
    [x + direction[0], y + direction[1]]
  end
  
  def all_squares_adjacent_to
    arr = []
    ALLDIR.each do |direction|
      arr << adj(direction)
    end
    arr
  end

  def all_empty_squares_adjacent_to
    arr = []
    ALLDIR.each do |direction|
      arr << Square.where(x: x + direction[0]).where(y: y + direction[1]).where(height: 0).where(game_id: game.id)
    end
    arr.reject! {|item| item.empty? }
    arr.map! do |obj|
      coord = []
      coord << obj[0].x
      coord << obj[0].y
      coord
    end
    arr
  end
  
  # to-do, this could return if the user's colour is correct 
  def topplable
    # is high enough
    # is my color
    height > 1
  end

# to-do    should this be private, should we check if square is nill?
  def valid_move(destination)
    square = game.get_square_from_coord(destination)
    
    return false if !(all_squares_adjacent_to.include? destination) || Square.offboard?(destination) || square.occupied?  || height < 2
    true 
  end

  
  class << self
    def offboard?(coord)
      coord[0] > 5 || coord[0] < 1 || coord[1] > 5 || coord[1] < 1 
    end
  end


end