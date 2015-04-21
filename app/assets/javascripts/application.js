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


  //to-do    can we refactor these methods to all go to one route which triggers a method calling method that calls the correct method based on some params or the db?? 

function doTheGame(){

console.log('inside doTheGame in application.js')

    $('.game-square').on('click',function(){

      if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "place") {

        $('.game-square').removeClass('active');
        $(this).addClass('active');
        var dataId = ($(this).attr('data-id'));

        $.ajax({
          url: '/games/' + currentGame + '/place',
          method: 'POST',
          data: { squareId: dataId }, 
          success: function(x) {
            console.log('ajax post was successful');
            console.log('x = ', x)

          },
          failure: function(x){
            console.log('ajax post failed')
          }
        })

    }
    // topple code
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple") {

      console.log(this);

      var dataId = ($(this).attr('data-id'));

      $.ajax({
          url: '/games/' + currentGame + '/topplecheck',
          method: 'POST',
          data: { squareId: dataId }, 
          success: function(x) {
            console.log('ajax post was successful');
            console.log('x = ', x)
            /* topplecheck returns 
            {
              {'clickable': true,
                'targets': [15,21,5,4]
              }
            }

            if (i can click it) {
                removeClass('unselected') from this and the target squares 
                addClass('topplable')  to the targetable squares

            } 
            else {
                nothing happens
            }

            */
          },
          failure: function(x){
            console.log('ajax post failed')
          }
        })     
      // topplecheck returns an enumerable containing, whether or not I can select that square (is it my color) and also an enumerable containing squares i can click on 



    }


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

