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

   console.log('Hotooooooo!');


$(function(){

console.log('heyinside')
    $('td').on('click',function(){
      $('td').removeClass('active');
      $(this).addClass('active');
      var dataId = ($(this).attr('data-id'));

      $.ajax({
        url: '/games/' + currentGame + '/place',
        method: 'POST',
        data: { squareId: dataId },
        success: function(x) {
          console.log('get succes' + x);

        },
        failure: function(x){
          console.log('failure')
        }
      })
      // $(this)
      // square = Square.find($(this).attr('id'));
    })

    $('#place-button').on('click', function(){
      console.log('clicked', $(this).text());
    })
    $('#topple-button').on('click', function(){
      console.log('clicked', $(this).text());
    })



  

})

