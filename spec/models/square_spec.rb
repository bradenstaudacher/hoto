require 'rails_helper'

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
end
