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
    console.log($(this).val())
    if($(this).val()=== "teacher"){
      $(".teacher-p").show();
      $(".school-input").show();
    }
    else if($(this).val()=== "friends_and_family"){
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

  // FOR READING URL TO DISPLAY IMG FILE
  function readURL(input) {
    if (input.files && input.files[0]) {
      console.log('FILE:', input.files[0]);
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#grant-img-preview').attr('src', e.target.result);
        $('#grant-img-preview').cropper({
          aspectRatio: 16 / 9,
          scalable: false,
          movable: false,
          zoomable: false
        });
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  // SHOW CROP MODAL ON FILE UPLOAD
  $("#grant_image").on('change', function(e){
    readURL(this);
    $("#blur-div").css('z-index', 1)
    $("#blur-div").fadeTo('slow',1);
    $('.crop-img').focus();
  });

  // ON GRANT UPDATE: IF CROPPED IMG USE AJAX CALL
  $('#new-grant').on('click', function(e){
    var img = $('form').data('file');
    if (img) {
      e.preventDefault();
      var user_id = $('form')[0].id.split("_")[2];
      var formdata = new FormData($('form')[0]);
      formdata.append("file", img);
      if (user_id){
        $.ajax({
          method: "PATCH",
          url: (`/grants/${user_id}/`),
          data: formdata,
          processData: false,
          contentType: false
        });
      }else{
        $.ajax({
          method: "POST",
          url: ("/grants/"),
          data: formdata,
          processData: false,
          contentType: false
        });
      }
    }
  });

  // CREATE NEW JPEG FILE WHEN YOU SAVE CROPPED IMG
  $('.crop-img').on('click', function(){
    $('#grant-img-preview').cropper('getCroppedCanvas').toBlob(function (blob) {
      var name = $('#grant_image')[0].files[0].name.split(".")[0] + Math.floor(Math.random() * 10000000).toString() + ".jpg"
      var new_img = new File([blob], name, {type: "image/jpeg"});
      $('form').data('file', new_img);
      url = URL.createObjectURL(new_img);
      $('.final-crop').attr('src', url);
      $('.final-crop').show();
      $('#grant-img-preview').cropper('destroy');
      $('#blur-div').css('z-index', -1);
      $('#blur-div').css('opacity', 0);
    });
  });


  // PAYMENT FUNCTIONS
  var handler = StripeCheckout.configure({
    key: 'pk_test_3oCK6GUkzy4PZFbsaDld0gTY',
    locale: 'auto',
    name: 'Berkeley Public Schools Fund',
    description: 'One-time donation',
    token: function(token) {
      $('input#stripeToken').val(token.id);
      $('form').submit();
    }
  });

  $('#donateButton').on('click', function(e) {
    e.preventDefault();

    $('#error_explanation').html('');

    var amount = $('input#amount').val();
    amount = amount.replace(/\$/g, '').replace(/\,/g, '')

    amount = parseFloat(amount);

    if (isNaN(amount)) {
      $('#error_explanation').html('<p>Please enter a valid amount in USD ($).</p>');
    }
    else if (amount < 5.00) {
      $('#error_explanation').html('<p>Donation amount must be at least $5.</p>');
    }
    else {
      amount = amount * 100; // Needs to be an integer!
      handler.open({
        amount: Math.round(amount)
      })
    }
  });

  $(window).on('popstate', function() {
    handler.close();
  });


});
