$(document).ready(function() {
  var build_under_form, do_alert, do_update_function, populate;
  do_update_function = function() {
    var arr, data;
    arr = $("ol.sortable").nestedSortable("toArray");
    data = "data=" + JSON.stringify(arr) + "&menuid=" + $("ol.sortable").attr("data-menuid");
    $.ajax({
      type: "POST",
      url: $('.js-settings').attr('data-site-url') + "admin/menus/save_menu",
      data: data,
      dataType: "html",
      success: function(data) {}
    });
  };
  do_alert = function() {
    $("#main-content .row > .col-md-12 .alert-wrapper").html("<div class=\"alert alert-success\"><button data-dismiss=\"alert\" class=\"close\" type=\"button\">x</button><strong>Success!</strong> Menu was successfully updated</div>");
    $("html,body").animate({
      scrollTop: $("#header").offset().top
    }, "slow");
  };
  build_under_form = function(data, selector) {
    $.ajax({
      type: "POST",
      url: $('.js-settings').attr('data-site-url') + "admin/menus/ajax_dropbox",
      data: data,
      dataType: "html",
      success: function(data) {
        populate(data, selector);
        $("input").iCheck({
          checkboxClass: "icheckbox_flat-grey",
          radioClass: "iradio_flat-grey"
        });
        $('.saveWrapper').removeClass('hidden');
      }
    });
  };
  populate = function(d, selector) {
    $(selector).append(d);
  };
  $("#menu-sortable-fields ol.sortable").nestedSortable({
    items: "li",
    maxLevels: 3
  });
  $(".update-menu").bind("click", function(e) {
    do_update_function();
    do_alert();
  });
  $("ol.sortable").on("click", "i.handler", function() {
    var container;
    container = $(" > .item-information", $(this).closest("li"));
    if (container.hasClass("active")) {
      $(this).removeClass("fa-minus");
      $(this).addClass("fa-plus");
      container.slideUp("slow");
      container.removeClass("active");
    } else {
      $(this).removeClass("fa-plus");
      $(this).addClass("fa-minus");
      container.slideDown("slow");
      container.addClass("active");
    }
  });
  $("select.mod").bind("change", function(e) {
    var form;
    form = $(this).closest("form");
    $("input[name=\"type\"]", form).val($(":selected", $(this)).attr("data-type"));
    $("input[name=label]", form).val($(":selected", $(this)).text());
  });
  $("#menu-forms form").bind("submit", function(e) {
    var data, dataString, formData, html, label, randomnumber, type;
    e.preventDefault();
    type = $(this).attr("data-type");
    data = $(this).serializeArray();
    dataString = $(this).serialize();
    if (data[2]["value"] === "") {
      label = "";
    } else {
      label = data[2]["value"];
    }
    randomnumber = Math.floor(Math.random() * 11);
    if (type === "custom") {
      if (($("input[name=customlink]", $(this)).val() !== "") && ($("input[name=label]", $(this)).val() !== "")) {
        html = "<li class=\"dd-item\" style=\"\" data-id=\"option_" + data[1]["value"] + "\" id=\"custom_" + randomnumber + "\" data-type=\"custom\" data-data=\"" + dataString + "\"><div class=\"dd-handle\">" + label + "<i class=\"fa fa-plus pull-right handler\"></i></div>";
        $("ol.sortable").append(html);
        build_under_form(data, "#custom_" + randomnumber);
      }
    } else {
      if (($("select[name=linkto]", $(this)).val() !== "") && ($("input[name=label]", $(this)).val() !== "")) {
        formData = $(this).serialize();
        html = "<li class=\"dd-item\" style=\"\" data-id=\"option_" + data[1]["value"] + "\" id=\"" + data[0]["value"] + "_" + randomnumber + "\" data-type=\"" + data[0]["value"] + "\" data-data=\"" + dataString + "\"><div class=\"dd-handle\">" + label + "<i class=\"fa fa-plus pull-right handler\"></i></div>";
        $("ol.sortable").append(html);
        build_under_form(data, "#" + data[0]["value"] + "_" + randomnumber);
      }
    }
    $(this)[0].reset();
  });

  /* 
      on save of individual li option - this will serialize the data to the html so when you 
      save the actual menu it will take this data and send it to the server
   */
  $("ol.sortable").on("click", ".submit-form", function() {
    var form_data;
    form_data = $(this).closest("form");
    $(this).closest("li").attr("data-data", form_data.serialize());
    $(this).closest("li").find('> .dd-handle > .list-name-option').text(form_data.find('input[name=label]').val());
    $(".update-menu").trigger("click");
  });

  /*
      remove the option form the list. The form is not updated until you click the update function
      at which point it serializes the data without the option in.
   */
  $("#menu-sortable-fields").on("click", ".delete-option", function(e) {
    var li;
    e.preventDefault();
    $(this).closest(".item-information").slideUp("slow");
    li = $(this).closest("li").fadeOut("slow");
    setTimeout((function(e) {
      $(li).remove();
    }), 1000);
  });
});
