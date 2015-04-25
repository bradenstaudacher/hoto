class Turn
  attr_accessor :actions, :colour
  def initialize(colour)
    self.colour = colour
    self.actions = []
  end
  def place(square)
    self.actions.push( Place.new( Action.square_to_coords(square ) ) )
  end
  def topple(square)
    t = Topple.new( Action.square_to_coords(square) )
    self.actions.push( t )
    t
  end
  def bloom(square)
    b = Bloom.new( Action.square_to_coords(square) )
    self.actions.push( b )
    b
  end
end