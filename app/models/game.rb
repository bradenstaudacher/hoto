class Game < ActiveRecord::Base
  has_many :squares
  has_and_belongs_to_many :players
  
  class << self 
    def board
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
      Square.all.each do |square, index|
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
  end
end
