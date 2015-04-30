// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
 if (window.console && window.console.log) {
 }
};

var pusher = new Pusher('e6e3668b059767b856df', {
  wsHost: "0.0.0.0",
  wsPort: "8080",
  wssPort: "8080",
  enabledTransports: ['ws', 'flash']
});
var channel = pusher.subscribe('games');

$(document).ready(function(){
  channel.bind('refresh_squares', function(data) {
    var game = data.gameid;
    var squares = data.board_html;
    var phase = data.phase;
    var turnstate = data.turnstate;
    var winnerName = data.winner_name
    var turn = data.turn
  
    if (game === parseInt(currentGame)) {
      gameActive = data.active;
      currentTurnstate = turnstate;
      currentPhase = phase;
      if (!gameActive){
        $('#player-turn-info').html("<h2 class ='game-over'> "+ winnerName +" wins!</h2>");
      }
    
      if (turnstate === currentUserColour) {
        console.log("In turnstate check");
        $('#turn-phase').text("Your turn to " + phase);
        $('#resign-btn').removeClass('disabled');
        if (phase === 'place') {
          $('#end-turn-button').addClass('disabled');
        } else {
          $('#end-turn-button').removeClass('disabled');
        }

      } else {
        $('#turn-phase').text("Waiting for opponent to " + phase);
        $('#resign-btn').addClass('disabled');
        $('#end-turn-button').addClass('disabled');
      }

      if (turn) {
        for(var i = 0; i < turn.actions.length; i ++){
          if (data.turn.actions[i].action_type === 'place') {
            console.log("in pusher place");
            var square_coords = data.turn.actions[0].coord;
            if (turn.actions.length === 1){
              changeGameBoard(squares);
            } else {
              bloomer();
            }
            // to-do abstract all topple directions into one function
          } else if (data.turn.actions[i].action_type === 'topple'){
            console.log("in pusher topple ");
            var squareX = data.turn.actions[0].coord.x;
            var squareY = data.turn.actions[0].coord.y;
            var destinationX = turn.actions[0].destination_coords[0].x;
            var destinationY = turn.actions[0].destination_coords[0].y;
            var direction = getDirection({x: squareX, y: squareY} , {x: destinationX , y: destinationY});

            if (direction === 'right') {
              console.log('right');
              var counter = 1;
              var amountArray = [0, 140, 260, 380];
                while (counter <= 3) {
                  var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')');
                  thing.addClass('fake-pieces');
                  thing.animate({ 
                    left: "+=" + amountArray[counter]
                  }, {
                  duration: 1000,
                    complete: function(){
                      if(turn.actions.length > 1){
                        toppleAction = getArrayOfTopples()
                        originSquare = {x: toppleAction[0].coord.x, y: toppleAction[0].coord.y, height: toppleAction[0].coord.height, colour: turn.colour}
                        arr = [originSquare]
                        destinationArray = toppleAction[0].destination_coords
                        for(var i = 0; i < destinationArray.length; i++){
                          arr = affectedToppleSquaresBuild(destinationArray[i].x, destinationArray[i].y, destinationArray[i].height, turn.colour, arr)
                        }
                        changeAffectedSquares(arr)
                        setTimeout(function(){
                          bloomer();
                        },500)
                      }
                    }
                  });
                  counter += 1;
                }

              if(turn.actions.length === 1) { 
                setTimeout(function(){
                  changeGameBoard(squares);  
                }, 2000);
              }
            } else if (direction === 'left') {
              console.log('left');
              var counter = 1;
              var amountArray = [0, 240, 480, 720];
              while (counter <= 3) {
                var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')');
                thing.addClass('fake-pieces');
                thing.animate({ 
                  left: "-=" + amountArray[counter]
                }, {
                duration: 1000,
                  complete: function(){
                    if(turn.actions.length > 1){
                        toppleAction = getArrayOfTopples()
                        originSquare = {x: toppleAction[0].coord.x, y: toppleAction[0].coord.y, height: toppleAction[0].coord.height, colour: turn.colour}
                        arr = [originSquare]
                        destinationArray = toppleAction[0].destination_coords
                        for(var i = 0; i < destinationArray.length; i++){
                          arr = affectedToppleSquaresBuild(destinationArray[i].x, destinationArray[i].y, destinationArray[i].height, turn.colour, arr)
                        }
                        changeAffectedSquares(arr)
                        setTimeout(function(){
                          bloomer();
                        },500)
                    }
                  }
                });
                counter += 1;
              }
              if(turn.actions.length === 1) { 
                setTimeout(function(){
                  changeGameBoard(squares);
                }, 2000);
              }

            } else if(direction === 'up') {
              console.log('up');
              var counter = 1;
              var amountArray = [0, 244, 485, 727];
              while (counter <= 3) {
                var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')');
                thing.addClass('fake-pieces');
                thing.animate({ 
                  top: "-=" + amountArray[counter]
                }, {
                  duration: 1000,
                  complete: function(){
                    if(turn.actions.length > 1){
                         toppleAction = getArrayOfTopples()
                        originSquare = {x: toppleAction[0].coord.x, y: toppleAction[0].coord.y, height: toppleAction[0].coord.height, colour: turn.colour}
                        arr = [originSquare]
                        destinationArray = toppleAction[0].destination_coords
                        for(var i = 0; i < destinationArray.length; i++){
                          arr = affectedToppleSquaresBuild(destinationArray[i].x, destinationArray[i].y, destinationArray[i].height, turn.colour, arr)
                        }
                        changeAffectedSquares(arr)
                        setTimeout(function(){
                          bloomer();
                        },500)
                    }
                  }
                });
                counter += 1;
              }
              if(turn.actions.length === 1) { 
                setTimeout(function(){
                  changeGameBoard(squares);
                }, 2000);
              }
            } else {
              console.log('down');
              var counter = 1;
              var amountArray = [0, 242, 484, 726];
              while (counter <= 3) {
                var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')');
                thing.addClass('fake-pieces');
                thing.animate({ 
                "top" : "+=" + amountArray[counter]
                }, {
                  duration: 1000,
                  complete: function(){
                    if(turn.actions.length > 1){
                        toppleAction = getArrayOfTopples()
                        originSquare = {x: toppleAction[0].coord.x, y: toppleAction[0].coord.y, height: toppleAction[0].coord.height, colour: turn.colour}
                        arr = [originSquare]
                        destinationArray = toppleAction[0].destination_coords
                        for(var i = 0; i < destinationArray.length; i++){
                          arr = affectedToppleSquaresBuild(destinationArray[i].x, destinationArray[i].y, destinationArray[i].height, turn.colour, arr)
                        }
                        changeAffectedSquares(arr)
                        setTimeout(function(){
                          bloomer();
                        },500)
                    }
                  }
                });
                counter += 1;
              }
              if(turn.actions.length === 1) { 
                setTimeout(function(){
                  changeGameBoard(squares);    
                }, 2000);
              }
            }
          }
        }
      }
    }
    function changeGameBoard(squares){
      for(var i = 0; i < squares.length ; i++){
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y +'"]').removeClass('black white empty');
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y +'"]').addClass(squares[i].colour);
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y +'"]').html(createPieces(squares[i].height));
      }
    }

    function changeAffectedSquares(squares){
      for(var i = 0; i < squares.length; i ++){
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white empty');
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').html(createPieces(squares[i].height));
      }
    }

    function createPieces(number){
      x = "<span class='pieces'><p class='piece-numbers'>" + number + "</p></span>";
      return Array(number + 1).join(x);
    }
    function getDirection(from_coords, to_coords){
      var direction ='';
      switch ([from_coords.x - to_coords.x,from_coords.y - to_coords.y].toString()) {
         case "0,1": return "up";
         case "1,0": return "left";
         case "-1,0": return "right";
         case "0,-1": return "down";
      }
      return direction;
    }

    function bloomer() {
      console.log("in pusher bloom")
      var bloomArray = getArrayOfBlooms()
      var superColour = turn.colour;
      for(var i = 0; i < bloomArray.length; i++) {
        var current = bloomArray[i]
        var adj = current.adjacent_squares
        var theAffectedSquares = [{x: current.coord.x, y: current.coord.y, height: current.coord.height, colour: turn.colour}]
        function affectedSquaresBuild(x,y,height, colour){
          if (!(x > 5 || x < 1 || y > 5 || y < 1)){
            theAffectedSquares.push({x: x, y: y, height: height, colour: colour})
          } 
        }
        for (var n = 0; n < adj.length; n++){
          affectedSquaresBuild(adj[n].x,adj[n].y, adj[n].height, turn.colour)
        }
        createBloomAnimation(bloomArray[i], 1000 * i, theAffectedSquares)
        createFinalRefresh(1000 * bloomArray.length + 100)
      }
    }

     function affectedToppleSquaresBuild(x,y,height, colour, arrayOfAffectedSquares){
        if (!(x > 5 || x < 1 || y > 5 || y < 1)){
          arrayOfAffectedSquares.push({x: x, y: y, height: height, colour: colour})
        } 
        return arrayOfAffectedSquares
      }
    
    function createBloomAnimation(coord, time, squares){
      setTimeout(function(){
        doOneBloom(coord)
      },time + 100)
       setTimeout(function(){
           changeAffectedSquares(squares);
      },time + 1000)
    }

    function createFinalRefresh(time){
       setTimeout(function(){
           changeAffectedSquares(squares);
      },time)
    }
// to-do combine the below two array building functions
    function getArrayOfBlooms(){
      return turn.actions.filter(function(action){
        if(action.action_type === "bloom"){
          return action;
        }
      });
    }
    function getArrayOfTopples(){
      return turn.actions.filter(function(action){
        if(action.action_type === "topple"){
          return action;
        }
      });
    }


    function doOneBloom(bloomCoord){
      console.log('bloomArray[i] in doOneBloom', bloomCoord)
      var squareX = bloomCoord.coord.x
      var squareY = bloomCoord.coord.y
      console.log('bloomed on: ', squareX, squareY);
      $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"]').append("<span class ='pieces'><p class='piece-numbers'>3</p></span")
      var counter = 1
      var directions = [0, "top", "top", "left", "left"]
      var amountArray = [0, "+=242", "-=244", "-=240", "+=140"]
      while (counter <= 4) {
        var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
        thing.addClass('fake-pieces')
        if (directions[counter] === "top") {
          thing.animate({ 
              "top" : amountArray[counter]
          }, 900)
        } else {
            thing.animate({ 
              "left" : amountArray[counter]
          },900)
        }
        counter += 1
      }
    }
  }); //channel.bind
});//end document ready

