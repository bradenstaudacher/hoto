class GameController < ApplicationController
  def index
    # @board = Game::BOARD
    @board = Game.board
    @squares = Square.all.to_json
  end
end
