class Game < ActiveRecord::Base
  has_many :squares
  has_and_belongs_to_many :users

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
