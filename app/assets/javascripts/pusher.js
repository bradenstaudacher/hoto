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
   // debugger;
   var squares = data.board_html;
   var game = data.gameid;
   var phase = data.phase;
   var turnstate = data.turnstate;
   var winnerName = data.winner_name
   var turn = data.turn

   gameActive = data.active;
   currentTurnstate = turnstate;
   currentPhase = phase;


   if (game === parseInt(currentGame)) {
    if (!gameActive){
       $('#info-div').append('<p>'+ winnerName +' won the hoto</p>');
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
          changeGameBoard(squares);
        }else if (data.turn.actions[i].action_type === 'topple'){
          console.log("in pusher topple ")
          var square_coords = data.turn.actions[0].coord
            $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(1)').addClass('fake-pieces')
           $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(1)').animate({ 
          left: "+=130"
          }, 1000)
           $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(2)').addClass('fake-pieces')
           $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(2)').animate({ 
          left: "+=235"
          }, 1000)
           $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(3)').addClass('fake-pieces')
          $('td.game-square[data-x="'+ data.turn.actions[0].coord.x+'"][data-y="'+ data.turn.actions[0].coord.y +'"] span:nth-child(3)').animate({ 
          left: "+=340"
          }, 1000)
          setTimeout(function(){
            changeGameBoard(squares)
            
          }, 2000)
        }else {
          console.log("in pusher bloom")
          var square_coords = data.turn.actions[0].coord

          // setTimeout(function(){
          //   changeGameBoard();
            
          // }, 3000);
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


  function createPieces(number){
    x = "<span class='pieces'>" + number + "</span>"
    return Array(number + 1).join(x)
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