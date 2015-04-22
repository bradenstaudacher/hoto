class Square < ActiveRecord::Base
  belongs_to :game


  def place(player_colour)
    if (player_colour == colour) || (colour == "empty")
      
      self.height += 1
      self.colour = player_colour
      self.save

      game.update(phase: 'topple')
      
      if self.bloomable?
        self.bloom
        game.switch_turnstate
      end
      # returns true because it's been placed. for game controller
      return true
    end
    false
  end
  
  def occupied?
    height > 0
  end

  def bloom
    square_colour = colour
    update(height: 0)
    update(colour: 'empty')
    all_squares_adjacent_to.each do |coord|
      if !Square.offboard?(coord)
        square = game.get_square_from_coord(coord)
        square.height += 1
        square.colour = square_colour
        square.save
        if square.bloomable?
          square.bloom
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


  def topple(direction)
    return false unless valid_move([x + direction[0], y + direction[1]])
      square_colour = colour
      num_squares_affected = height
      update(height: 0)
      update(colour: 'empty')

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
        if square.bloomable?
          square.bloom
           game.switch_turnstate

        end
      end

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
       x = obj[0].id % 25
       if x == 0  
        x = 25
       end 
       x
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