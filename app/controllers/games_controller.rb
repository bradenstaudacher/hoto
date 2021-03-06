class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all.includes(:users)
  end

  # GET /games/1
  # GET /games/1.json
  def show
    
    @game = Game.find(params[:id])

    @board = Game.board params[:id]
    @squares = Square.where(game_id: params[:id])
    @id = params[:id]
    # @turnstate = Game.find(params[:id]).turnstate
    # @phase = Game.find(params[:id]).phase
    @current_colour = GamesUser.set_player_colour(session[:user_id], @id)

    @all_users = GamesUser.where(game_id: params[:id])
    
    games_user_white = GamesUser.where(game_id: params[:id], colour: 'white')
    @user1 = User.find(games_user_white[0].user_id)

    if (@all_users.length > 1)
      games_user_black = GamesUser.where(game_id: params[:id], colour: 'black')
      @user2 = User.find(games_user_black[0].user_id)
    end

    @user1_colour = GamesUser.get_colour_by_id(params[:id], @user1.id)
   
    if @user2 != nil
      @user2_colour = GamesUser.get_colour_by_id(params[:id], @user2.id)
    else
      @user2_colour = "empty"
    end

    # @active = Game.find(params[:id]).active
    @winner_name = User.find(@game.winner_id).name if !@game.active
    # Pusher['games'].trigger('new_game', {
    #   :test => "test!"
    # })

  end

  def available_games_refresh
    @games = Game.all.includes(:users).order(:created_at).reverse
    @player_id = session[:user_id]
    render :partial => "games/availablegames"
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
      @game = Game.create(turnstate: "white", phase: 'place', active: true, moves_counter: 0)
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
# to-do   can all of the pusher logic be abstracted to a method
  def click_to_place 
    puts "this is the params id in place " + params[:id]
    @the_right_game = Game.includes(:squares).find(params[:id])
    @current_square = @the_right_game.squares.where(x: params[:square_x], y: params[:square_y])[0]

    turn = @the_right_game.turn

    successful_place = @current_square.place(@the_right_game.turnstate, turn)
    if successful_place
      @updated_game = Game.find(params[:id])
      @updated_game.update_active
      @winner_name = User.find(@updated_game.winner_id).name if !@updated_game.active

      Pusher['games'].trigger('refresh_squares', {
        :test => "placed square!",
        :board_html => @updated_game.squares,
        :phase => @updated_game.phase,
        :turnstate => @updated_game.turnstate,
        :gameid => @updated_game.id,
        :active => @updated_game.active,
        :winner_name => @winner_name,
        :turn => turn
        })

    end
    phase_and_turnstate = {phase: @updated_game.phase, turnstate: @updated_game.turnstate, active: @updated_game.active }

    render json: phase_and_turnstate 


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

    turn = @the_right_game.turn
    
    if from_square.topple([dest_square.x - from_square.x, dest_square.y - from_square.y], turn)
      @updated_game = Game.find(params[:id])
      @updated_game.update_active
      @winner_name = User.find(@updated_game.winner_id).name if !@updated_game.active
      
      Pusher['games'].trigger('refresh_squares', {
          :test => "placed square!",
          :board_html => @updated_game.squares,
          :phase => @updated_game.phase,
          :turnstate => @updated_game.turnstate,
          :gameid => @updated_game.id,
          :active => @updated_game.active,
          :winner_name => @winner_name,
          :turn => turn
          })

    end
    
    if @updated_game
      render json: @updated_game
    else
      render json: @the_right_game
    end
  end

  def end_turn
    @this_game = Game.find(params[:id])
    @this_game.switch_turnstate


    @this_turnstate = @this_game.turnstate
    @winner_name = User.find(@this_game.winner_id).name if !@this_game.active

    Pusher['games'].trigger('refresh_squares', {
        :test => "end turn!",
        :board_html => @this_game.squares,
        :phase => @this_game.phase,
        :turnstate => @this_game.turnstate,
        :gameid => @this_game.id,
        :active => @this_game.active,
        :winner_name => @winner_name

        })
    phase_and_turnstate = {phase: @this_game.phase, turnstate: @this_game.turnstate}
    render json: phase_and_turnstate
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def resign
    @this_game = Game.find(params[:id])
    @this_game.update(active: false)
    @this_game.winner_id = @this_game.users.where.not(id: params[:loser])[0].id
    @this_game.loser_id = params[:loser]
    @this_game.save
    Pusher['games'].trigger('refresh_squares', {
      :test => "end turn!",
      :board_html => @this_game.squares,
      :phase => @this_game.phase,
      :turnstate => @this_game.turnstate,
      :gameid => @this_game.id,
      :active => @this_game.active,
      :winner_name => @this_game.users.where.not(id: params[:loser])[0].name

    })
    winner_and_active = {winner: @this_game.winner_id, active: @this_game.active}
    render json: winner_and_active
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
