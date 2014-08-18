$(document).ready(function() {
  $("body").on("keypress", "#addGroupInput", function(e) {
    $("#addGroupInput").val($("#addGroupInput").val().toLowerCase().replace(" ", "-"));
    if (e.which === 13) {
      e.preventDefault();
      $(".addGroupInput").trigger("click");
    }
  });
  $("body").on("click", ".addGroupInput", function() {
    $.ajax({
      type: "POST",
      url: settings.attr('data-site-url') + "admin/settings/create_user_group",
      data: "key=" + $("#addGroupInput").val(),
      dataType: "html",
      success: function(data) {
        $(".userGroupOptions").append(data);
        $("#addGroupInput").val("");
      }
    });
  });
  $("body").on("click", ".remove-user-group", function(e) {
    e.preventDefault();
    if (confirm("Are you sure? Please make sure update all users with this group")) {
      $(this).closest(".form-group").remove();
    }
  });
});
