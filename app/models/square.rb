class Square < ActiveRecord::Base
  belongs_to :game
  
  LEFT = -1
  RIGHT = 1
  
  def get_coord(x)
    [@square.x, @square.y]
  end
    
  def get_square_from_coord(arr)
    Square.where(x: arr[0]).where(y: arr[1])[0]
  end

  def bloom
    update(height: 0)
    all_squares_adjacent_to.each do |square|
      square.height += 1
      square.save
    end
  end

  def topple_right
    if valid_move(right_adj)
      num_squares_affected = height
      update(height: 0)
      next_square = get_square_from_coord([x+1, y])
      while num_squares_affected > 0
        next_square.height += 1
        next_square.save
        next_square = get_square_from_coord([next_square.x+1, next_square.y])
        num_squares_affected -= 1
      end
    end
  end

  def topple_left
    if valid_move(left_adj)
      num_squares_affected = height
      update(height: 0)
      next_square = get_square_from_coord([x-1, y])
      while num_squares_affected > 0
        next_square.height += 1
        next_square.save
        next_square = get_square_from_coord([next_square.x-1, next_square.y])
        num_squares_affected -= 1
      end
    end
  end

  def topple_up
    puts "method called"
    if valid_move(top_adj)
      puts "valid move"
      num_squares_affected = height
      update(height: 0)
      next_square = get_square_from_coord([x, y-1])
      while num_squares_affected > 0
        puts "in loop"
        next_square.height += 1
        next_square.save
        next_square = get_square_from_coord([next_square.x, next_square.y-1])
        num_squares_affected -= 1
      end
    end
  end

  def topple_down
    if valid_move(bottom_adj)
      num_squares_affected = height
      update(height: 0)
      next_square = get_square_from_coord([x, y+1])
      while num_squares_affected > 0
        next_square.height += 1
        next_square.save
        next_square = get_square_from_coord([next_square.x, next_square.y+1])
        num_squares_affected -= 1
      end
    end
  end
  
  def get_adj(xdirection)
    get_square_from_coord([x + xdirection, y])
  end
  
  def left_adj
    get_square_from_coord([x-1, y])
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
      arr << left_adj
      arr << right_adj
      arr << top_adj
      arr << bottom_adj
      arr
  end

  def occupied?(coord)
      get_square_from_coord(coord).height > 0
  end
  
  def off_board?(coord)
    coord[0] > 5 || coord[0] < 1 || coord[1] > 5 || coord[1] < 1 
  end

  def valid_move(to)

    return false if off_board?([to.x, to.y]) || !(all_squares_adjacent_to.include? to) || occupied?([to.x, to.y])  || height < 2
    true 
  end
  
end