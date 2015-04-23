# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "bigdog", games_played: 0, games_won: 0, email: "big@dog.com", current_rating: 0, password: "testes", password_confirmation: "testes")
User.create(name: "crunchy pete", games_played: 0, games_won: 0, email: "cool@dog.com", current_rating: 0, password: "testes", password_confirmation: "testes")

game_id_counter = 1

7.times do 
  
  Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 0)

  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: game_id_counter, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  Game.find(game_id_counter).users << User.first
  p = GamesUser.where(game_id: game_id_counter).where(user_id: User.first.id)[0]
  p.colour = 'white'
  p.save
  Game.find(game_id_counter).users << User.last
  n = GamesUser.where(game_id: game_id_counter).where(user_id: User.last.id)[0]
  n.colour = 'black'
  n.save
  game_id_counter += 1
end



