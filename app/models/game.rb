class Game < ActiveRecord::Base
  has_many :squares
  has_and_belongs_to_many :players
  
  class << self 
    def board
      board = []
      # Square.all.each do |square|
      #   board << square.height
      # end
      # board

      row1 = []
      row2 = []
      row3 = []
      row4 = []
      row5 = []
      Square.all.each do |square, index|
        if row1.length < 5
          row1 << square.height
        elsif row2.length < 5
          row2 << square.height
        elsif row3.length < 5
          row3 << square.height
        elsif row4.length < 5
          row4 << square.height
        else 
          row5 << square.height
        end
      end
      board << row1 << row2 << row3 << row4 << row5
    end
  end
end
