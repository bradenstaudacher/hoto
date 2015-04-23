// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
 if (window.console && window.console.log) {
   window.console.log(message);
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
   if (game === parseInt(currentGame)) {
     for(var i=0; i < 25; i++){
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white normal');
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
        $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"] .pieces').text(squares[i].height);
      }
        $('#turn-phase').text("It is " + turnstate + "'s turn to " + phase);
    }
  });
    

  // channel.bind('pusher:subscription_succeeded', function(data) {
  //  console.log('pusher subscription succeeded', data.test);
  // });


});//end document ready
