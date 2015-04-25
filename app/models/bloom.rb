class Bloom < Action
  attr_accessor :adjacent_squares
  def initialize(coords)
    super
    self.adjacent_squares = []
  end
  
end