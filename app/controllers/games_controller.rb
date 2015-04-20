# class GamesController < ApplicationController
#   def index
#     # @board = Game::BOARD
#     @board = Game.board
#     @games = Square.all.to_json
#   end
# end


class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @board = Game.board params[:id]
    @squares = Square.all.to_json

    @id = params[:id]
    @turnstate = Game.find(params[:id]).turnstate
    if session[:user_id]
      @current_colour = GamesUser.where(user_id: session[:user_id]).where(game_id: params[:id])[0].colour
    else
      @current_colour = "empty"
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.create(turnstate: "white", active: true)
    # @game = Game.new(game_params)

    # respond_to do |format|
    #   if @game.save
    #     format.html { redirect_to @game, notice: 'game was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @game }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @game.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity } 
      end
    end
  end

  def click_to_place 
    puts params[:squareId]
    square_id = params[:squareId].to_i
    puts "this is the params id in place " + params[:id]

    @the_right_game = Game.find(params[:id])

    @current_square = @the_right_game.squares[square_id - 1]

    @current_square.place(@the_right_game.turnstate)
    if @the_right_game.turnstate == "white"
      @the_right_game.turnstate = "black"
      @the_right_game.save
    else
      @the_right_game.turnstate = "white"
      @the_right_game.save
    end

    # Square.find(square_id)

    @square = Square.all
    render json: @square
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params[:game]
    end
end
