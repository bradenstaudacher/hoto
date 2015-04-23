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
    @squares = Square.where(game_id: params[:id])
    @id = params[:id]
    @turnstate = Game.find(params[:id]).turnstate
    @phase = Game.find(params[:id]).phase
    @current_colour = GamesUser.set_player_colour(session[:user_id], @id)

    # Pusher['games'].trigger('new_game', {
    #   :test => "test!"
    # })

  end

  def is_record?

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
    @player_id = session[:user_id]
    if @player_id
      @game = Game.create(turnstate: "white", active: true)
      GamesUser.create_assoc_white(@game.id, @player_id)
      Game.make_squares(@game.id)
    end
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
    puts "this is the params id in place " + params[:id]
    @the_right_game = Game.find(params[:id])
    @current_square = @the_right_game.squares.where(x: params[:square_x], y: params[:square_y])[0]

    if @current_square.place(@the_right_game.turnstate)
      @board_new = Game.find(params[:id])
      Pusher['games'].trigger('refresh_squares', {
        :test => "placed square!",
        :board_html => @board_new.squares,
        :phase => @board_new.phase,
        :turnstate => @board_new.turnstate,
        :gameid => @board_new.id

        })
    # else
    #   Pusher['games'].trigger('new_game', {
    #     :test => "didnt square!"
    #     })
    end

 
    # Square.find(square_id)

    # to-do   how do we get rid of these things but not have 500 errors
    # @square = Square.all
    render text: @board_new.phase
    # render json: @current_square if placed = 'placed'
  end

  def topplecheck
    square_id = params[:squareId].to_i
    @the_right_game = Game.find(params[:id])
    @current_square = @the_right_game.squares[square_id - 1]
# to-do    is the square-colour the same as player color and is it height min 2

# to-do    What does @targetable_squares equal??
    
    
    @targetable_squares = @current_square.all_empty_squares_adjacent_to
    @targetable_squares << @current_square.topplable
    render json: @targetable_squares
  end

  def topplecall
    @the_right_game = Game.find(params[:id])
    from_square = @the_right_game.squares.where(x: params[:from][0].to_i, y: params[:from][1].to_i)[0]
    dest_square = @the_right_game.squares.where(x: params[:dest][0].to_i, y: params[:dest][1].to_i)[0]
    if from_square.topple([dest_square.x - from_square.x, dest_square.y - from_square.y])
      @board_new = Game.find(params[:id])
      Pusher['games'].trigger('refresh_squares', {
          :test => "placed square!",
          :board_html => @board_new.squares,
          :phase => @board_new.phase,
          :turnstate => @board_new.turnstate,
          :gameid => @board_new.id

          })
    end

    render json: @board_new
  end

  def end_turn
    @this_game = Game.find(params[:id])
    @this_game.switch_turnstate


    @this_turnstate = @this_game.turnstate
    puts @this_turnstate.is_a? String
    render text: @this_turnstate
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
