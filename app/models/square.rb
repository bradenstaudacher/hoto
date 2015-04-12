class Square < ActiveRecord::Base
  belongs_to :game
  
  # @square =  
  
  def get_coord(x)
    # @square = ????
    [@square.x, @square.y]
  end
    
  def get_square_from_coord(arr)
    Square.where(x: arr[0]).where(y: arr[1])[0]
  end

  def bloom(x)
     # set current square's .height to 0
     # set adjacent square .height += 1    
  end

  def topple_left(coord)
    #num_squares_to_attack = current_square.height 
    #set the current square's .height to 0
    #which direction is the topple in?
    #numSquares
  end

  def topple_right(coord)
    @square.height = 0 if valid_move
    right_adj(coord)
  end

  def topple_up(coord)
  end

  def topple_down(coord)
  end

  def left_adj(coord)
      [coord[0]-1, coord[1]]
  end

  def right_adj(coord)
      [coord[0]+1, coord[1]]
  end

  def top_adj(coord)
      [coord[0], coord[1]-1]
  end

  def bottom_adj(coord)
      [coord[0], coord[1]+1]
  end

  def all_adj(coord)
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
  
  def offboard?(coord)
    # coord not on board
  end


  def valid_move(from, to)
    valid_move = true
    valid_move = false if !(all_adj(from).include? to)
    valid_move = false if occupied?(to)
    #valid_move = false if offboard?(to)
    valid_move
  end

end