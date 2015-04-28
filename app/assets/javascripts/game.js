$(function(){
  $('#create-game-button').on('click',function(){
    console.log("Inside the game maker");
    $.ajax({ url: '/games', type: 'POST'});
    console.log("After ajax");
  });
  $('.join-game-button').on('click',function(){
    console.log("Join game clicked");
    $.ajax({ url: '/games/:id', type: 'GET'});
    console.log("After ajax");
  });
});