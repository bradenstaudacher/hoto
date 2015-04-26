// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
 if (window.console && window.console.log) {
   // window.console.log(message);
 }
};

var pusher = new Pusher('e6e3668b059767b856df');
var channel = pusher.subscribe('games');

$(document).ready(function(){
  channel.bind('refresh_squares', function(data) {
   // console.log('newgame', data.test);
   // $("#game-board").html(data.board_html)
   var game = data.gameid;
   var squares = data.board_html;
   var phase = data.phase;
   var turnstate = data.turnstate;
   var winnerName = data.winner_name
   var turn = data.turn
   console.log('here is data.board_html')
   console.log(data.board_html)
   if (game === parseInt(currentGame)) {
   gameActive = data.active;
   currentTurnstate = turnstate;
   currentPhase = phase;
    if (!gameActive){
       $('#player-turn-info').html("<marquee><h2 class ='game-over'> "+ winnerName +" won the hoto!</h2><img src='http://d3at4pok3dofi3.cloudfront.net/gifs/86889bd80fbb45c6ac15794d2de5ac4f.gif' style='height: 150px; width: 150px;'></marquee>");

    } 
    
    // for(var i=0; i < 25; i++){
    //   console.log(i);
    //   $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white empty');
    //   $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
    //   $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').html("<span class='pieces'>"+ squares[i].height + "</span>");
    // }
    $('#turn-phase').text("It is " + turnstate + "'s turn to " + phase);

    if (turn) {
      for(var i = 0; i < turn.actions.length; i ++){
        if (data.turn.actions[i].action_type === 'place') {
          console.log("in pusher place")
          var square_coords = data.turn.actions[0].coord
            // for(var i=0; i < 25; i++){
            //     console.log(i);
            //     $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white empty');
            //     $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
            //     $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').html("<span class='pieces'>"+ squares[i].height + "</span>");
            // }

          if (turn.actions.length === 1){
            changeGameBoard(squares);
          }else {
            bloomer();
          }
        }else if (data.turn.actions[i].action_type === 'topple'){
          console.log("in pusher topple ")
          
          var squareX = data.turn.actions[0].coord.x
          var squareY = data.turn.actions[0].coord.y
          var destinationX = turn.actions[0].destination_coords[0].x
          var destinationY = turn.actions[0].destination_coords[0].y


          var direction = getDirection({x: squareX, y: squareY} , {x: destinationX , y: destinationY})

          if (direction === 'right') {
            console.log('right')
            var counter = 1
            var amountArray = [0, 140, 260, 380]
             while (counter <= 3) {
              var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
             thing.addClass('fake-pieces')
             thing.animate({ 
              left: "+=" + amountArray[counter]
              }, {
                duration: 1000,
                complete: function(){
                  if(turn.actions.length > 1){
                    bloomer()
                  }
                }
              })
             counter += 1
            }

            if(turn.actions.length === 1) { 
              setTimeout(function(){
                changeGameBoard(squares)    
              }, 2000)
            }
         }else if (direction === 'left') {
            console.log('left')

            var counter = 1
            var amountArray = [0, 240, 480, 720]
            while (counter <= 3) {
              var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
             thing.addClass('fake-pieces')
             thing.animate({ 
              left: "-=" + amountArray[counter]
              }, {
                duration: 1000,
                complete: function(){
                  if(turn.actions.length > 1){
                    bloomer()
                  }
                }
              })
             counter += 1
           }
            if(turn.actions.length === 1) { 
              setTimeout(function(){
                changeGameBoard(squares)    
              }, 2000)
            }

         }else if(direction === 'up') {
            console.log('up')
            var counter = 1
            var amountArray = [0, 244, 485, 727]
            while (counter <= 3) {
              var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
             thing.addClass('fake-pieces')
             thing.animate({ 
              top: "-=" + amountArray[counter]
              }, {
                duration: 1000,
                complete: function(){
                  if(turn.actions.length > 1){
                    bloomer()
                  }
                }
              })
             counter += 1
           }
            if(turn.actions.length === 1) { 
              setTimeout(function(){
                changeGameBoard(squares)    
              }, 2000)
            }
         }else{
            console.log('down')
            var counter = 1
            var amountArray = [0, 242, 484, 726]
            while (counter <= 3) {
              var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
             thing.addClass('fake-pieces')
             thing.animate({ 
              "top" : "+=" + amountArray[counter]
              }, {
                duration: 1000,
                complete: function(){
                  if(turn.actions.length > 1){
                    bloomer()
                  }
                }
              })
             counter += 1
           }
            if(turn.actions.length === 1) { 
              setTimeout(function(){
                changeGameBoard(squares)    
              }, 2000)
            }
         }
        }
      }
    }
    

    }
  function changeGameBoard(squares){  
     for(var i=0; i < 25; i++){
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white empty');
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').html(createPieces(squares[i].height));
    }
  }

  function changeAffectedSquares(squares){
    // var affectedSquares = [{x:1,y:2},[x: 3,y: 5],[x: 5,y: 6]]     Have an array of affect squares
    for(var i = 0; i < squares.length; i ++){
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white empty');
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
      $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').html(createPieces(squares[i].height));
    }
  }


  function createPieces(number){
    x = "<span class='pieces'>" + number + "</span>"
    return Array(number + 1).join(x)
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
    
    var superColour = turn.colour
    // changeGameBoard(squares)
      for(var i = 0; i < bloomArray.length; i++) {
        var current = bloomArray[i]
        var adj = current.adjacent_squares
        var theAffectedSquares = [
            {x: current.coord.x, y: current.coord.y},
            {x: adj[0].x, y: adj[0].y},
            {x: adj[1].x, y: adj[1].y},
            {x: adj[2].x, y: adj[2].y},
            {x: adj[3].x, y: adj[3].y}
        ]

        createBloomAnimation(bloomArray[i], 1000 * i, theAffectedSquares)
      }
  }
  
  function createBloomAnimation(coord, time, squares){
    setTimeout(function(){
      doOneBloom(coord)
    },time + 100)
     setTimeout(function(){
         changeAffectedSquares(squares);
    },time + 1000)
  }


  function getArrayOfBlooms(){
    return turn.actions.filter(function(action){
          if(action.action_type === "bloom"){
            return action
          }
      })
  }

  function doOneBloom(bloomCoord){
    console.log('bloomArray[i] in doOneBloom', bloomCoord)
   var squareX = bloomCoord.coord.x
      var squareY = bloomCoord.coord.y

      console.log('bloomed on: ', squareX, squareY);

      // $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"]').append("<span class ='pieces'></span")

     var counter = 1
      var directions = [0, "top", "top", "left", "left"]

      var amountArray = [0, "+=242", "-=244", "-=240", "+=140"]

      while (counter <= 4) {
        var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
       thing.addClass('fake-pieces')
       // console.log('thing is equal to : ', thing);
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
    
  // channel.bind('pusher:subscription_succeeded', function(data) {
  //  console.log('pusher subscription succeeded', data.test);
  // });


});//end document ready



// $('.pieces').on('click',function(){
//   $(this).animate({ 
//      left: "+=50"
//   }, 1000)
// })




// $('#info-div > h3.player-black').on('click',function(){
//   var thing = $(this)
//   console.log('a', thing)
//   thing.animate({
// 'font-size':  10 
//   },{
//   duration: 1000,
//   complete: function(){
//   thing.animate({
//   'font-size' : 100
// },500)
// }
// })
// });
