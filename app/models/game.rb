class Game < ActiveRecord::Base
  has_many :squares
  has_and_belongs_to_many :players
  
  BOARD = [
    ['x','x','x','x','x'],
    ['x','x','x','x','x'],
    ['x','x','x','x','x'],
    ['x','x','x','x','x'],
    ['x','x','x','x','x']
  ] 

end
