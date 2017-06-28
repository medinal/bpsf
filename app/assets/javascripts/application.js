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

  $('.donation').on('click', function(e) {

    $('#error_explanation').html('');

    var amount = $('input#amount').val();
    amount = amount.replace(/\$/g, '').replace(/\,/g, '')
    amount = parseFloat(amount);

    if (isNaN(amount)) {
      e.preventDefault();
      $('#error_explanation').html('<p>Please enter a valid amount in USD ($).</p>');
    }
    else if (amount < 5.00) {
      e.preventDefault();
      $('#error_explanation').html('<p>Donation amount must be at least $5.</p>');
    }
    else if ($('#donateButton')[0]){
      e.preventDefault();
      amount = amount * 100; // Needs to be an integer!
      handler.open({
        amount: Math.round(amount)
      })
    }
    else{
      var title = $('.grant-row .columns h3')[0].innerHTML;
      var amount = $('#amount').val()
      if(confirm(`Are you sure you want to donate $${amount} to ${title}?`)){
      }else{
        e.preventDefault();
      }
    }
  });

  $(window).on('popstate', function() {
    handler.close();
  });

  //Disable Button to prevent duplicate payments
  $('form').on('submit', function(){
    $('.donation').attr('disabled', true);
  });

  $('.new-card').on('click', function(){
    $('.new-card-form').show();
    $('#credit-card table').hide();
    $(this).hide();
  });

  var stripe = Stripe('pk_test_3oCK6GUkzy4PZFbsaDld0gTY');
  var elements = stripe.elements();
  var style = {
    base: {
      fontSize: '20px',
      fontFamily: 'MuseoSans300'
    },
    complete: {
      color: 'green'
    }
  };
  var card = elements.create('card', {style: style});
  if($('.card-element')[0]){
    card.mount('#credit-card .card-element');
  }

  // SHOW EDIT CARD FORM
  $('.badge.click.warning').on('click', function(){
    $('#credit-card table').hide();
    $('.new-card').hide();
    var cardForm = $(this).closest('tr').attr('id');
    $(`.${cardForm}`).show();
  });

  // TO DELETE CARD
  $('.badge.click.alert').on('click', function(){
    var cardForm = $(this).closest('tr').attr('id');
    var id = $(`.${cardForm} input#card_id`).val();
    $(this).siblings('input#card_id').val(id);
    $(this).closest('form').submit();
  });

  // SHOW TABLE ON TAB CLICK
  $('#credit-card-label').on('click', function(){
    $('.edit-card-form').hide();
    $('.new-card-form').hide();
    $('.new-card').show();
    $('#credit-card table').show();
  });

  // SHOW TABLE ON CANCEL CLICK
  $('.cancel-edit').on('click', function(){
    $('#credit-card table').show();
    $(this).closest('form').parent().hide();
    $('.new-card').show();
  });

  // CREATE NEW CARD
  $('.card_submit').on('click', function(e){
    e.preventDefault();
    var me = this;
    var form = $(me).closest('form');
    var owner = {
      name: form.find('#name').val(),
      address_line1: form.find('#address_line1').val(),
      address_line2: form.find('#address_line2').val(),
      address_city: form.find('#address_city').val(),
      address_state: form.find('#address_state').val(),
      address_country: form.find('#address_country').val(),
    }
    stripe.createToken(card, owner).then(function(result) {
      if (result.error) {
        // Inform the user if there was an error
        $('p.alert').text(result.error.message);
        $(window).scrollTop($('p.alert').position().top);
      } else {
        // Send the token to your server
        $('#card_token').val(result.token.id);
        form.submit();
      }
    });
  });
});
