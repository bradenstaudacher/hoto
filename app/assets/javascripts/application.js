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

          },
          failure: function(x){
            console.log('ajax post failed')
          }
        })
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

      $('#topple-button').on('click', function(){
        console.log('clicked', $(this).text());
      })

    //   $('.game-square').on('click',function(){

    //     if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple") {

    //       $('.game-square').removeClass('active');
    //       $(this).addClass('active');
    //       var dataId = ($(this).attr('data-id'));


    //       $.ajax({
    //         url: '/games/' + currentGame + '/place',
    //         method: 'POST',
    //         data: { squareId: dataId }, 
    //         success: function(x) {
    //           console.log('ajax post was successful');

    //         },
    //         failure: function(x){
    //           console.log('ajax post failed')
    //         }
    //       })
    //     }
    // });
  $('.game-square').on('click',function(){
    if ((currentUser !== 0) && (currentTurnstate === currentUserColour) && currentPhase === "topple"){
      console.log('Inside click function')
      var square1 = this;
      $(square1).attr('data-id')
      console.log("Square 1 is set")
      console.log(square1)
      console.log($(square1).attr('data-id'))
      
      $('.game-square').on('click',function(){
        var square2 = this;
        $(square2).attr('data-id')
        console.log("Square 2 is set")
        console.log(square2)
        console.log($(square2).attr('data-id'))
        console.log("same square" ,square1 == square2)        
      })
    }
  }) 

}

