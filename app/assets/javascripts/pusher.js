// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
 if (window.console && window.console.log) {
   window.console.log(message);
 }
};

var pusher = new Pusher('e6e3668b059767b856df');
var channel = pusher.subscribe('games');

$(document).ready(function(){
  channel.bind('new_game', function(data) {
   console.log('newgame', data.test);
   // $(".board").html(data.board_html)
  });

  channel.bind('pusher:subscription_succeeded', function(data) {
   console.log('pusher subscription succeeded', data.test);
  });


});//end document ready
