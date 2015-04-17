require 'rails_helper'
require 'pry'

RSpec.describe Square, type: :model do

  before :each do
    counter = 1
    while counter <= 5 
      i = 1
      while i <= 5
        Square.create(x: i, y: counter, height: 0)
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
    @square2 = Square.get_square_from_coord([2,1])
    @square13 = Square.get_square_from_coord([3,3])
    @square25 = Square.get_square_from_coord([5,5])
    expect(@square1).to eq(Square.find(1))
    expect(@square2).to eq(Square.find(2))
    expect(@square13).to eq(Square.find(13))
    expect(@square25).to eq(Square.find(25))
  end

  ############## TOPPLE LEFT #########################

  it "can topple left off the board with height 2" do
    @topplesquare = Square.find(7)
    @topplesquare.update(height: 2)
    expect(@topplesquare.height).to eq(2)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(7).height).to eq(0)
    expect(Square.find(6).height).to eq(1)
  end

  it "can topple left off the board with height 3" do
    @topplesquare = Square.find(7)
    @topplesquare.update(height: 3)

    expect(@topplesquare.height).to eq(3)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(7).height).to eq(0)
    expect(Square.find(6).height).to eq(1)
  end

  it "can topple left onto a square that has height" do
    @topplesquare = Square.find(5)
    @topplesquare.update(height: 3)
    @topplesquare2 = Square.find(3)
    @topplesquare2.update(height: 2)

    expect(@topplesquare.height).to eq(3)
    expect(@topplesquare2.height).to eq(2)
    @topplesquare.topple(Square::LEFT)
    expect(Square.find(5).height).to eq(0)
    expect(Square.find(4).height).to eq(1)
    expect(Square.find(3).height).to eq(3)
    expect(Square.find(2).height).to eq(1)
  end

    ############## TOPPLE RIGHT #########################

  it "can topple right off the board with height 2" do
    @topplesquare = Square.find(9)
    @topplesquare.update(height: 2)
    expect(@topplesquare.height).to eq(2)
    @topplesquare.topple(Square::RIGHT)
    expect(Square.find(9).height).to eq(0)
    expect(Square.find(10).height).to eq(1)
  end

  it "can topple right off the board with height 3" do
    @topplesquare = Square.find(9)
    @topplesquare.update(height: 3)

    expect(@topplesquare.height).to eq(3)
    @topplesquare.topple(Square::RIGHT)
    expect(Square.find(9).height).to eq(0)
    expect(Square.find(10).height).to eq(1)
  end

  it "can topple right onto a square that has height" do
    @topplesquare = Square.find(1)
    @topplesquare.update(height: 3)
    @topplesquare2 = Square.find(3)
    @topplesquare2.update(height: 2)

    expect(@topplesquare.height).to eq(3)
    expect(@topplesquare2.height).to eq(2)
    @topplesquare.topple(Square::RIGHT)
    expect(Square.find(1).height).to eq(0)
    expect(Square.find(2).height).to eq(1)
    expect(Square.find(3).height).to eq(3)
    expect(Square.find(4).height).to eq(1)
  end

    ############## TOPPLE UP #########################

  it "can topple up off the board with height 2" do
    @topplesquare = Square.find(9)
    @topplesquare.update(height: 2)
    expect(@topplesquare.height).to eq(2)
    @topplesquare.topple(Square::UP)
    expect(Square.find(9).height).to eq(0)
    expect(Square.find(4).height).to eq(1)
  end

  it "can topple up off the board with height 3" do
    @topplesquare = Square.find(9)
    @topplesquare.update(height: 3)

    expect(@topplesquare.height).to eq(3)
    @topplesquare.topple(Square::UP)
    expect(Square.find(9).height).to eq(0)
    expect(Square.find(4).height).to eq(1)
  end

  it "can topple up onto a square that has height" do
    @topplesquare = Square.find(23)
    @topplesquare.update(height: 3)
    @topplesquare2 = Square.find(13)
    @topplesquare2.update(height: 2)

    expect(@topplesquare.height).to eq(3)
    expect(@topplesquare2.height).to eq(2)
    @topplesquare.topple(Square::UP)
    expect(Square.find(23).height).to eq(0)
    expect(Square.find(18).height).to eq(1)
    expect(Square.find(13).height).to eq(3)
    expect(Square.find(8).height).to eq(1)
  end

    ############## TOPPLE DOWN #########################

  it "can topple down off the board with height 2" do
    @topplesquare = Square.find(18)
    @topplesquare.update(height: 2)
    expect(@topplesquare.height).to eq(2)
    @topplesquare.topple(Square::DOWN)
    expect(Square.find(18).height).to eq(0)
    expect(Square.find(23).height).to eq(1)
  end

  it "can topple down off the board with height 3" do
    @topplesquare = Square.find(18)
    @topplesquare.update(height: 3)

    expect(@topplesquare.height).to eq(3)
    @topplesquare.topple(Square::DOWN)
    expect(Square.find(18).height).to eq(0)
    expect(Square.find(23).height).to eq(1)
  end

  it "can topple down onto a square that has height" do
    @topplesquare = Square.find(3)
    @topplesquare.update(height: 3)
    @topplesquare2 = Square.find(13)
    @topplesquare2.update(height: 2)

    expect(@topplesquare.height).to eq(3)
    expect(@topplesquare2.height).to eq(2)
    @topplesquare.topple(Square::DOWN)
    expect(Square.find(3).height).to eq(0)
    expect(Square.find(8).height).to eq(1)
    expect(Square.find(13).height).to eq(3)
    expect(Square.find(18).height).to eq(1)
  end

  ################## BLOOM ########################

  it "can check if a piece is bloomable" do
    @topplesquare = Square.find(13)
    @topplesquare.update(height: 4)
    expect(@topplesquare.bloomable?).to eq(true)
  end

  it "can distribute pieces to all 4 sides" do
    @topplesquare = Square.find(7)
    @topplesquare.update(height: 4)
    @topplesquare.bloom
    expect(@topplesquare.height).to eq(0)
    expect(Square.find(2).height).to eq(1)
    expect(Square.find(6).height).to eq(1)
    expect(Square.find(8).height).to eq(1)
    expect(Square.find(12).height).to eq(1)
  end


  it "can topple on another square and auto-bloom it" do
    @topplesquare = Square.find(3)
    @topplesquare.update(height: 2)
    @topplesquare2 = Square.find(13)
    @topplesquare2.update(height: 3)

    expect(@topplesquare.height).to eq(2)
    expect(@topplesquare2.height).to eq(3)
    @topplesquare.topple(Square::DOWN)
    expect(Square.find(3).height).to eq(0)
    expect(Square.find(13).height).to eq(0)
    expect(Square.find(8).height).to eq(2)
    expect(Square.find(12).height).to eq(1)
    expect(Square.find(14).height).to eq(1)
    expect(Square.find(18).height).to eq(1)
  end

  it "can bloom and trigger another bloom" do
    @topplesquare = Square.find(3)
    @topplesquare.update(height: 2)
    @topplesquare2 = Square.find(13)
    @topplesquare2.update(height: 3)
    @topplesquare3 = Square.find(14)
    @topplesquare3.update(height: 3)

    expect(@topplesquare.height).to eq(2)
    expect(@topplesquare2.height).to eq(3)
    @topplesquare.topple(Square::DOWN)
    expect(Square.find(3).height).to eq(0)
    expect(Square.find(13).height).to eq(1)
    expect(Square.find(8).height).to eq(2)
    expect(Square.find(12).height).to eq(1)
    expect(Square.find(18).height).to eq(1)
    expect(Square.find(14).height).to eq(0)
    expect(Square.find(9).height).to eq(1)
    expect(Square.find(19).height).to eq(1)
    expect(Square.find(15).height).to eq(1)
  end

  ############### PLACE #################
  
  it "cannot be placed on an empty square with enemy colour" do
    @topplesquare = Square.find(8)
    @topplesquare.update(colour: "black")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(0)
  end

  it "can be placed on an empty square with no colour" do
    @topplesquare = Square.find(8)
    @topplesquare.update(colour: "empty")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(1)
  end

  it "can be placed on an empty square of same colour" do
    @topplesquare = Square.find(8)
    @topplesquare.update(colour: "white")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(1)
  end

  it "can be placed on a square with height 1 of same colour" do
    @topplesquare = Square.find(8)
    @topplesquare.update(height: 1)
    @topplesquare.update(colour: "white")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(2)
  end

  it "can be placed on a square with height 2 of same colour" do
    @topplesquare = Square.find(8)
    @topplesquare.update(height: 2)
    @topplesquare.update(colour: "white")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(3)
  end

  it "can be placed on a square with height 3 of same colour and it blooms" do
    @topplesquare = Square.find(8)
    @topplesquare.update(height: 3)
    @topplesquare.update(colour: "white")
    @topplesquare.place("white")
    expect(@topplesquare.height).to eq(0)
    @topplesquare2 = Square.find(3)
    @topplesquare3 = Square.find(7)
    @topplesquare4 = Square.find(9)
    @topplesquare5 = Square.find(13)
    expect(@topplesquare2.height).to eq(1)
    expect(@topplesquare3.height).to eq(1)
    expect(@topplesquare4.height).to eq(1)
    expect(@topplesquare5.height).to eq(1)
  end

end
