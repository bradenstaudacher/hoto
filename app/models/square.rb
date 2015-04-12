class Square < ActiveRecord::Base
  belongs_to :game
  
  LEFT = -1
  RIGHT = 1
  
  def get_coord(x)
    # @square = ????
    [@square.x, @square.y]
  end
    
  def get_square_from_coord(arr)
    Square.where(x: arr[0]).where(y: arr[1])[0]
  end

  def bloom(x)
    # all_squares_adjacent_to
     # set current square's .height to 0
     # set adjacent square .height += 1    
  end

  def topple_left
    #num_squares_to_attack = current_square.height 
    #set the current square's .height to 0
    #which direction is the topple in?
    #numSquares
  end

  def topple_right
    return false unless valid_move
      num_squares = height 
      update(height: 0)
      binding.pry
      self.right_adj
  end

  def topple_up
  end

  def topple_down
  end
  
  def get_adj(xdirection)
    get_square_from_coord([x + xdirection, y])
  end
  
  def right_adj
      get_square_from_coord([x+1, y])
  end

  def top_adj
      get_square_from_coord([x, y-1])
  end

  def bottom_adj
      get_square_from_coord([x, y+1])
  end

  def all_squares_adjacent_to
      arr = []
      arr << left_adj(coord)
      arr << right_adj(coord)
      arr << top_adj(coord)
      arr << bottom_adj(coord)
      arr
  end

  def occupied?(coord)
      get_square_from_coord(coord).height > 0
  end
  
  def off_board?(coord)
    coord[0] > 5 || coord[0] < 1 || coord[1] > 5 || coord > 1 
    # coord not on board
  end

  def valid_move(from, to)
     true
     false if !(all_squares_adjacent_to(from).include? to) || occupied?(to) || off_board?(to)
  end
  
end