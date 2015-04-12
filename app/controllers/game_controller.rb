class GameController < ApplicationController
  def index
    # @board = Game::BOARD
    @board = Game.board
  end
end
