require 'rails_helper'
require 'pry'

RSpec.describe Square, type: :model do

  before :each do
    counter = 1
    while counter <= 5 
      i = 1
      while i <= 5
        Square.create(x: counter, y: i, height: 0)
        i += 1
      end
      counter += 1
    end
  end

  it "creates the squares" do
    expect(Square.all.length).to eq(25)
  end
  it "can be accessed by coords" do
    @square1 = Square.get_square_from_coord([1,1])
    @square2 = Square.get_square_from_coord([1,2])
    @square13 = Square.get_square_from_coord([3,3])
    @square25 = Square.get_square_from_coord([5,5])
    expect(@square1).to eq(Square.find(1))
    expect(@square2).to eq(Square.find(2))
    expect(@square13).to eq(Square.find(13))
    expect(@square25).to eq(Square.find(25))
  end

  it "can topple off the board with height 2" do
    @topplesquare = Square.find(7)
    @topplesquare.update(height: 2)
    expect(@topplesquare.height).to eq(2)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(7).height).to eq(0)
    expect(Square.find(2).height).to eq(1)
  end

  it "can topple off the board with height 3" do
    @topplesquare = Square.find(7)
    @topplesquare.update(height: 3)
    expect(@topplesquare.height).to eq(3)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(7).height).to eq(0)
    expect(Square.find(2).height).to eq(1)
  end

  it "can topple onto a square that has height" do
    @topplesquare = Square.find(21)
    @topplesquare.update(height: 3)
    @topplesquare2 = Square.find(11)
    @topplesquare2.update(height: 2)
    expect(@topplesquare.height).to eq(3)
    expect(@topplesquare2.height).to eq(2)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(21).height).to eq(0)
    expect(Square.find(11).height).to eq(3)
    expect(Square.find(16).height).to eq(1)
    expect(Square.find(6).height).to eq(1)
  end

end
