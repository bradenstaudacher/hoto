class GameController < ApplicationController
  def index
    @board = Game::BOARD
  end
end
