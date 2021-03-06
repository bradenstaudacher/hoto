// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require pusher
//= require_tree .


  //to-do    can we refactor these methods to all go to one route which triggers a method calling method that calls the correct method based on some params or the db?? 
function doTheGame(){
var arr = [];
var endButtonClicked = false;
console.log('inside doTheGame in application.js');
  $('.game-square').on('click',function(){
      console.log('clicked game square');
      // place code below
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && (currentPhase === "place") && (gameActive === true)) {
      console.log("passed place check, game thinks we are in place");
      console.log('aaaaaaaaaa', gameActive);
      $('.game-square').removeClass('active');
      $(this).addClass('active');
      var square_x = ($(this).attr('data-x'));
      var square_y = ($(this).attr('data-y'));
      var coordinate = {
        'square_x': square_x,
        'square_y': square_y
      };

      $.ajax({
        url: '/games/' + currentGame + '/place',
        method: 'POST',
        data: coordinate,
        dataType: 'json',
        success: function(hash) {
          currentPhase = hash.phase;
          currentTurnstate = hash.turnstate;
          gameActive = hash.active;
          endButtonClicked = false;
          $('.game-square').removeClass('active');

        },
        error: function(phase, message){
          console.log(phase);
          console.log('ajax post failed', message);
          $('.game-square').removeClass('active');
        }
      });

    }
    // topple code
      
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple" && (gameActive === true)) {
      console.log('gameactive : ', gameActive);
      console.log('its in topple code application js');
      $(this).addClass('active');
      var topple_x = ($(this).attr('data-x'));
      var topple_y = ($(this).attr('data-y'));    
      arr.push([topple_x, topple_y]);
      console.log('array is equal to :', arr);
      if (arr.length === 2) {
        $('.game-square').removeClass('active');
        $.ajax({
          url: '/games/' + currentGame + '/topplecall',
          method: 'POST',
          data: { from: arr[0], dest: arr[1] },
          dataType: 'json',
          success: function(game) {
            console.log('ajax post was successful');      
            currentTurnstate = game.turnstate;
            gameActive = game.active;
            arr = [];
          },
          error: function(newTurnstate, message){
            console.log('ajax post failed');
            console.log(newTurnstate);
            console.log(message);
            arr = [];
          }
        });
      }    
    }
  });// end of click game square

  $('#end-turn-button').on('click', function(){
    console.log('clicked', $(this).text());
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple") {
      if (endButtonClicked === false) {
        endButtonClicked = true;
        console.log("passed user check");
        $.ajax({
          url: '/games/' + currentGame + '/end',
          method: 'POST',
          dataType: "json",
          success: function(hash) {
            currentPhase = hash.phase;
            currentTurnstate = hash.turnstate;
            console.log('ajax post was successful');
          },
          error: function(hash, message){
            console.log(hash);
            console.log(message);
            console.log('ajax post failed');
          }
        });
      }
    }
  });

  $('#resign-btn').on('click',function(){
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour)) {
      $.ajax({
        url: '/games/' + currentGame + '/resign',
        method: 'POST',
        data: { loser: currentUser }, 
        dataType: "json",
        success: function(hash) {
          console.log(hash);
          gameActive = hash.active;
          console.log('ajax post was successful');
        },
        error: function(hash, message){
          console.log(hash);
          console.log(message);
          console.log('ajax post failed');
        }
      });
    }
  });  
}