// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery.turbolinks
//= require jquery_ujs
//= require autocomplete-rails
//= require foundation
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  $(function(){ $(document).foundation(); });

  $(".friend-family-p").hide();
  $(".teacher-p").hide();
  $(".school-input").hide();

  $(".role").change(function(){
    $(".friend-family-p").hide();
    $(".teacher-p").hide();

    if($(this).val()=== "Teacher"){
      $(".teacher-p").show();
      $(".school-input").show();
    }
    else if($(this).val()=== "Friend/Family Member"){
      $(".friend-family-p").show();
      $(".school-input").hide();
      $(".school-input").val('')
    }
  })

  $('#submit').on('click', function(e){
    $('#status').val('pending');
    $('.input').children().prop('required',true);
    $('#new-grant').click();
  });

  $('#draft').on('click', function(e){
    $('#status').val('draft');
    $('.input').children().prop('required',false);
    $('#new-grant').click();
  });

  $('#filter-select').on('change', function(){
    $('#filter-form').submit();
  });

});
