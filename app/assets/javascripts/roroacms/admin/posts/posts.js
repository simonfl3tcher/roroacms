var readURL;

readURL = function(input) {
  var reader;
  if (input.files && input.files[0]) {
    reader = new FileReader();
    reader.onload = function(e) {
      $(".well").css({
        'background-position': 'center center',
        'background-image': 'url(' + e.target.result + ')',
        'background-repeat': 'no-repeat',
        'background-size': 'cover',
        'overflow': 'hidden'
      });
      $(".well input[name=has_cover_image]").val("Y");
    };
    reader.readAsDataURL(input.files[0]);
  }
};

$(document).ready(function() {
  $("body").on("click", ".add-cover-image", function(e) {
    e.preventDefault();
    $('#cover_image').trigger('click');
  });
  $("#cover_image").change(function() {
    readURL(this);
    $('.add-cover-image').addClass('hidden');
    $('.remove-cover-image').removeClass('hidden');
  });
  $("body").on("click", ".add-profile-image", function(e) {
    e.preventDefault();
    $('#admin_cover_picture').trigger('click');
  });
  $("body").on("click", ".remove-cover-image", function(e) {
    var input;
    input = $("#admin_cover_picture");
    $(".well").attr("style", "");
    $(this).addClass('hidden');
    $('.add-cover-image').removeClass('hidden');
    $(".well input[name=has_cover_image]").val('');
    input.replaceWith(input.val('').clone(true));
  });
  $("body").on("keypress", "#addAdditionalDataInput", function(e) {
    $("#addAdditionalDataInput").val($("#addAdditionalDataInput").val().toLowerCase().replace(" ", "-").replace(/[^a-zA-Z0-9_-]/g, ''));
    if (e.which === 13) {
      e.preventDefault();
      $(".addAdditionalDataInput").trigger("click");
    }
  });
  $("body").on("click", ".addAdditionalDataInput", function() {
    $.ajax({
      type: "POST",
      url: $('.js-settings').attr('data-site-url') + "admin/articles/create_additional_data",
      data: "key=" + $("#addAdditionalDataInput").val(),
      dataType: "html",
      success: function(data) {
        $(".additionalDataOptions").append(data);
        $("#addAdditionalDataInput").val("");
      }
    });
  });
  $("body").on("click", ".remove-additional-group", function(e) {
    e.preventDefault();
    if (confirm("Are you sure?")) {
      $(this).closest(".form-group").remove();
    }
  });
});
