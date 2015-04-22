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
//= require_tree .
//= require pusher

  //to-do    can we refactor these methods to all go to one route which triggers a method calling method that calls the correct method based on some params or the db?? 
function doTheGame(){
var arr = [] 

console.log('inside doTheGame in application.js')

    $('.game-square').on('click',function(){
      console.log('clicked game square')
      if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "place") {

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
          success: function(squares) {
            console.log('ajax post was successful');
            console.log('x = ', squares)
            for(var i=0; i < 25; i++){
              $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').removeClass('black white normal');
              $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"]').addClass(squares[i].colour);
              $('td.game-square[data-x="'+squares[i].x+'"][data-y="'+squares[i].y+'"] .pieces').text(squares[i].height);
            }
          },
          failure: function(x){
            console.log('ajax post failed')
          }
        })

    }
    // topple code
      
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple") {


      console.log('its in topple code application js');

      var topple_x = ($(this).attr('data-x'));
      var topple_y = ($(this).attr('data-y'));
      
      arr.push([topple_x, topple_y])

      console.log('Array is Below');
      console.log(arr);

      console.log();
      if (arr.length === 2) {
        $.ajax({
            url: '/games/' + currentGame + '/topplecall',
            method: 'POST',
            data: { from: arr[0], dest: arr[1] }, 
            success: function(x) {
              console.log('ajax post was successful');
              console.log('x = ', x)

              /* topplecheck returns */
             
              // if (currentUserColour ) {
                  
                  // var allsquares = $('.game-square')
                  // console.log('aaaaaaaa')
                  // allsquares[0]
                  // var that = $(this)
                  
                  // $(this).removeClass('unselected') 
                  // from this and the target squares 
                  // $()addClass('topplable') 
                   // to the targetable squares

              // } 
              // else {
             
              // }
              arr = []
            },
            failure: function(x){
              console.log('ajax post failed')
            }
          }) 
      }    
      }
      // topplecheck returns an enumerable containing, whether or not I can select that square (is it my color) and also an enumerable containing squares i can click on 



    


  });
        // $(this)
        // square = Square.find($(this).attr('id'));

      $('#end-turn-button').on('click', function(){
        console.log('clicked', $(this).text());
        if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple") {
          console.log(currentGame);

          $.ajax({
            url: '/games/' + currentGame + '/end',
            method: 'GET',
            success: function(x) {
              console.log('ajax post was successful');

            },
            failure: function(x){
              console.log('ajax post failed')
            }
          })
        }
      })

     
}

