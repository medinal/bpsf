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

  $('.profile.account').show();
  $('.profile-section').on('click', function(){
    $('.account-section-info .profile').hide();
    id = this.id;
    $(`.account-section-info .${id}`).show();
  });

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
        $('.resize-img').css('display', 'inline');
        $('#grant-img-preview').cropper({
          aspectRatio: 16 / 9,
          background: false,
          scalable: false,
          movable: false,
          zoomable: false
        });
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#grant_image").on('change', function(e){
    readURL(this);
  });
  // FOR CROPPING GRANT IMG
  $('#new-grant').on('click', function(e){
    e.preventDefault();
    debugger;
  });

  $('#crop-img').on('click', function(e){
    e.preventDefault();
    $("#blur-div").height($(window).height());
    $("#blur-div").width($(window).width());

  });

  $('#img-button').on('click', function(){
    $('#resize-img').html(`
      <img src="#" id="grant-img-preview">
    `);
    $('#grant-img-preview').cropper('getCroppedCanvas').toBlob(function (blob) {
      var name = $('#grant-img')[0].files[0].name.split(".")[0] + Math.floor(Math.random() * 10000000).toString() + ".jpg"
      var new_img = new File([blob], name, {type: "image/jpeg"});
      url = URL.createObjectURL(new_img);
      $('#final-crop').attr('src', url);
      var formdata = new FormData();
      var user_id = $('form')[0].id.split("_")[2]
      formdata.append(name, new_img);
      formdata.append("name", name)
      $.ajax({
        method: "PATCH",
        url: ("/user/avatar/" + user_id),
        data: formdata,
        processData: false,
        contentType: false
      });
    });
  });
});
