$(document).ready(function() {
  var settings = $('.js-settings');
  var editor = '';

  $('.contentReload').bind('click', function(e) {
    setTimeout(function() {
      editor = $(".editor").ghostDown();
    }, 5);
  });

  $("#term_name").bind("change keyup", function() {
    if ($("#term_id").val() === '') {
      $("#term_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-"));
    }
  });
  $("#menu_name").bind("change keyup", function() {
    $("#menu_key").val($(this).val().toLowerCase().split(" ").join("-"));
  });
  $(".checkall").change(function() {
    var checkboxes;
    checkboxes = $(this).closest("form").find(":checkbox");
    checkboxes.attr("checked", $(this).is(":checked"));
  });
  $.ajaxSetup({
    beforeSend: function(xhr) {
      xhr.setRequestHeader("X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content"));
    }
  });
  $(".updatepost").bind("click", function(e) {
    $("body").find("form").submit();
    e.preventDefault();
  });
  if ($("#post_post_title").length > 0) {
    setInterval((function() {
      var form, formData, content;
      
      if(editor != ''){
        content = editor.ghostDown('getMarkdown');
        $('#post_post_content').val(content);
      }

      if ($("#post_post_title").val() !== "") {
        form = $("form :input[name!='utf8'][name!='_method'][name!='authenticity_token']");
        formData = form.serialize();
        if ($("input[name=\"_method\"]").length > 0) {
          $.ajax({
            type: "POST",
            url: settings.attr('data-site-url') + "admin/articles/autosave",
            data: formData,
            success: function(data) {
              if (data !== 'f') {
                $("#revisionsContainer, #revisions").html(data);
              }
            }
          });
        }
      }
    }), 120000);
  }
  $("body").on('ifChecked ifUnchecked', 'th #check_all', function(event) {
    if (event.type === 'ifChecked') {
      $('tbody td input[type=checkbox]').iCheck('check');
    } else {
      $('tbody td input[type=checkbox]').iCheck('uncheck');
    }
  });
  $("#post_post_title").bind("change keyup", function() {
    if ($("#post_id").val() === '') {
      $("#post_post_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-"));
    }
  });
  $(".chosen-select").chosen({
    width: "100%",
    placeholder_text_multiple: "Please start typing..."
  });

  $("[rel='tooltip']").tooltip();
  dTable = $("#dtable").dataTable({
    bLengthChange: false,
    bInfo: false,
    iDisplayLength: parseInt(settings.attr('data-pagination-limit')),
    oLanguage: {
      sSearch: "",
      sEmptyTable: "There are currently no records!"
    },
    bSort: false,
    fnInitComplete: function(oSettings, json) {
      $("#dtable_paginate").detach().prependTo("#paginationWrapper");
    }
  });
  $("#tableFilter").keyup(function() {
    dTable.fnFilter($(this).val());
  });
});
