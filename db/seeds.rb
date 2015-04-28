# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


########################### USERS ###########################
User.create(name: "bigdog", games_played: 2, games_won: 1, email: "big@dog.com", current_rating: 1244, password: "testes", password_confirmation: "testes")
User.create(name: "crunchy pete", games_played: 32, games_won: 12, email: "cool@dog.com", current_rating: 1067, password: "testes", password_confirmation: "testes")
User.create(name: "leadboy", games_played: 5, games_won: 3, email: "lead@dog.com", current_rating: 907, password: "testes", password_confirmation: "testes")
User.create(name: "curliyq", games_played: 90, games_won: 80, email: "curly@dog.com", current_rating: 2011, password: "testes", password_confirmation: "testes")
User.create(name: "froggod77", games_played: 12, games_won: 5, email: "frog@dog.com", current_rating: 989, password: "testes", password_confirmation: "testes")
User.create(name: "gamorhod", games_played: 4, games_won: 1, email: "gamo@dog.com", current_rating: 1557, password: "testes", password_confirmation: "testes")
User.create(name: "lodki", games_played: 1, games_won: 0, email: "lmanswan@dog.com", current_rating: 823, password: "testes", password_confirmation: "testes")
User.create(name: "codman", games_played: 3, games_won: 0, email: "codman@dog.com", current_rating: 1450, password: "testes", password_confirmation: "testes")


########################### ELO ###########################
userc = 1
8.times do
  changec = rand(15) + rand(20)
  EloChange.create(user_id: userc, change: changec)
  changec = rand(15) + rand(20)
  EloChange.create(user_id: userc, change: changec)
  changec = rand(15) + rand(20)
  EloChange.create(user_id: userc, change: changec)
  userc += 1
end

########################### GAMES TO SPECTATE ###########################
rand_colour_array = ["black","white"]
game_id_counter = 1
user_counter = 1
5.times do 
  
  Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: rand(30))
  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      rand_height = rand(4)
      if rand_height == 0
        rand_colour = "empty"
      else
        rand_colour = rand_colour_array.sample
      end
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: rand_height, game_id: game_id_counter, colour: rand_colour)
      i += 1
    end
    counter += 1
  end
  Game.find(game_id_counter).users << User.find(user_counter)
  p = GamesUser.where(game_id: game_id_counter).where(user_id: User.find(user_counter).id)[0]
  p.colour = 'white'
  p.save
  Game.find(game_id_counter).users << User.find(user_counter+1)
  n = GamesUser.where(game_id: game_id_counter).where(user_id: User.find(user_counter+1).id)[0]
  n.colour = 'black'
  n.save
  game_id_counter += 1
  user_counter += 1
end

########################### GAMES TO JOIN ###########################

game_id_counter2 = 6
user_counter2 = 3
x = Time.now
5.times do 
  
  Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 0, created_at: x - (rand(6) * rand(100) * 10))
  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: game_id_counter2, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  Game.find(game_id_counter2).users << User.find(user_counter2)
  p = GamesUser.where(game_id: game_id_counter2).where(user_id: User.find(user_counter2).id)[0]
  p.colour = 'white'
  p.save
  game_id_counter2 += 1
  user_counter2 += 1
end

########################### GAMES TO SPECTATE FOR CRUNCHY PETE ###########################
game_id_counter3 = 11
user_counter3 = 4
2.times do
  
  Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 0)
  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: game_id_counter3, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  Game.find(game_id_counter3).users << User.find(user_counter3)
  p = GamesUser.where(game_id: game_id_counter3).where(user_id: User.find(user_counter3).id)[0]
  p.colour = 'white'
  p.save
  Game.find(game_id_counter3).users << User.find(2)
  n = GamesUser.where(game_id: game_id_counter3).where(user_id: User.find(2).id)[0]
  n.colour = 'black'
  n.save
  game_id_counter3 += 1
  user_counter3 += 1
end

################# Crazy Blooms ##############XXXxXXXXX

rand_colour_array = ["black","white"]
game_id_counter4 = 13
user_counter4 = 4
3.times do 
  
  Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 100)
  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      # rand_height = rand(4)
      # if rand_height == 0
      #   rand_colour = "empty"
      # else
        rand_colour = rand_colour_array.sample
      # end
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 3, game_id: game_id_counter4, colour: rand_colour)
      i += 1
    end
    counter += 1
  end
  Game.find(game_id_counter4).users << User.find(1)
  p = GamesUser.where(game_id: game_id_counter4).where(user_id: 1)[0]
  p.colour = 'white'
  p.save

  Game.find(game_id_counter4).users << User.find(2)
  n = GamesUser.where(game_id: game_id_counter4).where(user_id: 2)[0]
  n.colour = 'black'
  n.save

  game_id_counter4 += 1
  user_counter4 += 1
end


# ########### nine middle squares are bloomable  #######################

2.times do
qq = Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 100)
rand_colour_array = ["black","white"]
  counter = 1
  
   while counter <= 5
    i = 1
    while i <= 5
      # rand_height = rand(4)
      # if rand_height == 0
      #   rand_colour = "empty"
      # else
        rand_colour = rand_colour_array.sample
      # end
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: qq.id, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  these_squares = qq.squares
  these_squares.each do |squarey|
    if squarey.x > 1 && squarey.x < 5 && squarey.y > 1 && squarey.y < 5
      squarey.update(height: 3, colour: rand_colour)
    end
  end

  Game.find(qq.id).users << User.find(1)
  p = GamesUser.where(game_id: qq.id).where(user_id: User.find(1).id)[0]
  p.colour = 'white'
  p.save

  Game.find(qq.id).users << User.find(2)
  n = GamesUser.where(game_id: qq.id).where(user_id: User.find(2).id)[0]
  n.colour = 'black'
  n.save

end
# ################################ Outside Squares are bloomable #############
ff = Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 100)
rand_colour_array = ["black","white"]
  counter = 1
  
   while counter <= 5
    i = 1
    while i <= 5
      # rand_height = rand(4)
      # if rand_height == 0
      #   rand_colour = "empty"
      # else
        rand_colour = rand_colour_array.sample
      # end
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: ff.id, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  these_squares = ff.squares
  these_squares.each do |squarey|
    if squarey.y == 1 || squarey.y == 5 || squarey.x == 1 || squarey.x == 5
      squarey.update(height: 3, colour: rand_colour)
    end
  end

  Game.find(ff.id).users << User.find(1)
  p = GamesUser.where(game_id: ff.id).where(user_id: User.find(1).id)[0]
  p.colour = 'white'
  p.save

  Game.find(ff.id).users << User.find(2)
  n = GamesUser.where(game_id: ff.id).where(user_id: User.find(2).id)[0]
  n.colour = 'black'
  n.save


############# 5 middle squares bloomable
ff = Game.create(turnstate: "white", active: true, phase: 'place', moves_counter: 100)
rand_colour_array = ["black","white"]
  counter = 1
  
   while counter <= 5
    i = 1
    while i <= 5
      # rand_height = rand(4)
      # if rand_height == 0
      #   rand_colour = "empty"
      # else
        rand_colour = rand_colour_array.sample
      # end
      puts "i done did make a square!!"
      Square.create(x: i, y: counter, height: 0, game_id: ff.id, colour: 'empty')
      i += 1
    end
    counter += 1
  end
  these_squares = ff.squares
  these_squares.each do |squarey|
      Square.where(game_id: ff.id).where(x: 3).where(y: 3)[0].update(height: 3, colour: 'white')
      Square.where(game_id: ff.id).where(x: 2).where(y: 3)[0].update(height: 3, colour: 'black')
      Square.where(game_id: ff.id).where(x: 4).where(y: 3)[0].update(height: 3, colour: 'white')
      Square.where(game_id: ff.id).where(x: 3).where(y: 2)[0].update(height: 3, colour: 'black')
      Square.where(game_id: ff.id).where(x: 3).where(y: 4)[0].update(height: 3, colour: 'black')
  end

  Game.find(ff.id).users << User.find(1)
  p = GamesUser.where(game_id: ff.id).where(user_id: User.find(1).id)[0]
  p.colour = 'white'
  p.save

  Game.find(ff.id).users << User.find(2)
  n = GamesUser.where(game_id: ff.id).where(user_id: User.find(2).id)[0]
  n.colour = 'black'
  n.save

