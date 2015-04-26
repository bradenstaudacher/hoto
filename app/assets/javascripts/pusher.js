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
              }, 1000)
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
              }, 1000)
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
              }, 1000)
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
          // debugger
    var bloomArray = getArrayOfBlooms()
    
    var superColour = turn.colour
    // var that = this;

      for(var i = 0; i < bloomArray.length; i++) {
        // console.log('in the for loop bloomArray i s coords', bloomArray[i].coords)
        //      down up left right
            // setTimeout(function(){
       // var bloomCoord = bloomArray[i]

       // var first = bloomArray[0]
       // var second = bloomArray[1]
       

       // var callback = function(bloomCoord){
       //   console.log('setTimeout', bloomCoord)
       //    // console.log('bloomArray[i] in setTimeout', that.bloomArray[i])
       //    doOneBloom(bloomCoord)
       // }
       // .bind(this);

        // setTimeout(doOneBloom.bind(this,bloomCoord), 1000 * i);

          // doOneBloom(first)
        
        // setTimeout(function(){
        //   doOneBloom(second)
        // },2000)

        createBloomAnimation(bloomArray[i], 1000 * i)
        

      }
    // var squareX = bloomArray[i].coord.x
    //   var squareY = bloomArray[i].coord.y

    //   console.log('bloomed on: ', squareX, squareY);

    //   $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"]').append("<span class ='pieces'></span")

    //  var counter = 1
    //   var directions = [0, "top", "top", "left", "left"]

    //   var amountArray = [0, "+=242", "-=244", "-=240", "+=140"]

    //   while (counter <= 4) {
    //     var thing = $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"] span:nth-child('+ counter +')')
    //    thing.addClass('fake-pieces')
    //    console.log('thing is equal to : ', thing);
    //    if (directions[counter] === "top") {
    //       thing.animate({ 
    //           "top" : amountArray[counter]
    //       }, 1000)
    //     } else {
    //         thing.animate({ 
    //           "left" : amountArray[counter]
    //       },1000)
    //     }
    //    counter += 1
    //  
          // }, 1200 * (i))
            // can you settimeout with 0 ???? setTimeout
      // }
      setTimeout(function(){
         changeGameBoard(squares);
        
      }, 1250 * bloomArray.length);
  }
  
  function createBloomAnimation(coord, time){
    setTimeout(function(){
    doOneBloom(coord)
    },time)
    
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

      $('td.game-square[data-x="'+ squareX +'"][data-y="'+ squareY +'"]').append("<span class ='pieces'></span")

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
          }, 1000)
        } else {
            thing.animate({ 
              "left" : amountArray[counter]
          },1000)
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