class Topple < Action
  attr_accessor :destination_coords
  def initialize(coords)
    super
    self.destination_coords = []
  end
end