class Action
  Coord = Struct.new(:x, :y, :height)
  attr_accessor :coord, :action_type
  
  def initialize(square)
    self.coord = Action.square_to_coords(square)
    self.action_type = self.class.name.downcase
  end

  def self.square_to_coords(square)
    Coord.new(square.x, square.y, square.height)
  end
end