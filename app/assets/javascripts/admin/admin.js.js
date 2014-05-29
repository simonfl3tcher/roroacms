// Generated by CoffeeScript 1.7.1
(function() {
  $(document).ready(function() {
    $("#term_name").bind("change keyup", function() {
      $("#term_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-"));
    });
    $("#menu_name").bind("change keyup", function() {
      $("#menu_key").val($(this).val().toLowerCase().split(" ").join("-"));
    });
    $(".updatepost").bind("click", function(e) {
      $("body").find("form").submit();
      e.preventDefault();
    });
    if ($("#post_post_title").length > 0) {
      setInterval((function() {
        var action, c, form, formData, instance, method;
        if ($("#post_post_title").val() !== "") {
          form = $("form");
          method = form.attr("method").toLowerCase();
          action = form.attr("action");
          formData = form.serialize();
          for (instance in CKEDITOR.instances) {
            c = CKEDITOR.instances[instance].getData();
          }
          formData += "&ck_content=" + encodeURIComponent(c);
          if ($("input[name=\"_method\"]").length > 0) {
            $.post("/admin/posts/autosave_update", formData, function(data) {
              if (data !== 'f') {
                $("#revisionsContainer, #revisions").html(data);
              }
            });
          }
        }
      }), 120000);
    }
    $("#dtable th .iCheck-helper").click(function() {
      var checkboxes;
      checkboxes = $(this).closest("form").find(":checkbox");
      if ($(this).parent().hasClass('checked')) {
        $('tbody td input[type=checkbox]').iCheck('check');
      } else {
        $('tbody td input[type=checkbox]').iCheck('uncheck');
      }
    });
    $("#post_post_title").bind("change keyup", (function() {
      $("#post_post_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-"));
    }));
    $(".chosen-select").chosen({
      width: "100%",
      placeholder_text_multiple: "Please start typing..."
    });
    $('.contentReload').bind('click', function(e) {});
    $.scrollUp();
  });

}).call(this);
