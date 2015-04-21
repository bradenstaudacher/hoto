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
      end
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
        square = game.get_square_from_coord(coord)[0]
        square.height += 1
        square.colour = square_colour
        square.save
        if square.bloomable?
          square.bloom
        end
      end
    end
    game.switch_turnstate
  end

  def bloomable?
    height == 4
  end

  LEFT = [-1, 0]
  RIGHT = [1, 0]
  UP = [0, -1]
  DOWN = [0, 1]
  ALLDIR = [LEFT, RIGHT, UP, DOWN]


  def topple?


    

    # RETURN [true, 1, 2, 3]
  end




  def topple(direction)
    return false unless valid_move([x + direction[0], y + direction[1]])
      
      square_colour = colour
      num_squares_affected = height
      update(height: 0)

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

  def valid_move(to)
    square = game.get_square_from_coord(to)
    return false if !(all_squares_adjacent_to.include? to) || Square.offboard?(to) || square.occupied?  || height < 2
    true 
  end

  
  class << self
    def offboard?(coord)
      coord[0] > 5 || coord[0] < 1 || coord[1] > 5 || coord[1] < 1 
    end
  end


end