class Square < ActiveRecord::Base
  belongs_to :game

  def place
    self.height += 1
    self.save
  end
  
  def occupied?
    self.height > 0
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
      next_square = Square.get_square_from_coord([x+1, y])
      while num_squares_affected > 0
        next_square.height += 1
        next_square.save
        next_square = Square.get_square_from_coord([next_square.x+1, next_square.y])
        num_squares_affected -= 1
      end
    end
  end

  # def topple_left
  #   if valid_move(left_adj)
  #     num_squares_affected = height
  #     update(height: 0)

  #     next_square = Square.get_square_from_coord([x-1, y])

  #     while num_squares_affected > 0 && !Square.offboard?([x-1, y])
  #       next_square.height += 1
  #       next_square.save
  #       next_square = Square.get_square_from_coord([next_square.x-1, next_square.y])
  #       num_squares_affected -= 1
  #     end
  #   end
  # end

  def topple_left
    return false unless valid_move(left_adj)
      
      num_squares_affected = height
      update(height: 0)

      coords_affected = []
      counter = 1
      while counter <= num_squares_affected
        coords_affected << [x - counter, y]
        counter += 1 
      end
      coords_affected.select! do |coord|
        !Square.offboard?(coord)
      end
      coords_affected.each do |coord|
        square = Square.get_square_from_coord(coord)
        square.height += 1
        square.save
      end
  end

  def topple_up
    puts "method called"
    if valid_move(top_adj)
      puts "valid move"
      num_squares_affected = height
      update(height: 0)
      next_square = Square.get_square_from_coord([x, y-1])
      while num_squares_affected > 0
        puts "in loop"
        next_square.height += 1
        next_square.save
        next_square = Square.get_square_from_coord([next_square.x, next_square.y-1])
        num_squares_affected -= 1
      end
    end
  end

  def topple_down
    if valid_move(bottom_adj)
      num_squares_affected = height
      update(height: 0)
      next_square = Square.get_square_from_coord([x, y+1])
      while num_squares_affected > 0
        next_square.height += 1
        next_square.save
        next_square = Square.get_square_from_coord([next_square.x, next_square.y+1])
        num_squares_affected -= 1
      end
    end
  end
  
  def left_adj
    [x-1, y]
  end
  
  def right_adj
      Square.get_square_from_coord([x+1, y])
  end

  def top_adj
      Square.get_square_from_coord([x, y-1])
  end

  def bottom_adj
      Square.get_square_from_coord([x, y+1])
  end

  def all_squares_adjacent_to
      arr = []
      arr << left_adj
      arr << right_adj
      arr << top_adj
      arr << bottom_adj
      arr
  end

  def valid_move(to)
    square = Square.get_square_from_coord(to)
    return false if !(all_squares_adjacent_to.include? to) || Square.offboard?(to) || square.occupied?  || height < 2
    true 
  end

  
  class << self
    def offboard?(coord)
      coord[0] > 5 || coord[0] < 1 || coord[1] > 5 || coord[1] < 1 
    end
    # DOESNT DO ANYTHING USEFUL RIGHT NOW

    def get_square_from_coord(coord)
      Square.where(x: coord[0]).where(y: coord[1])[0]
    end
  end
end