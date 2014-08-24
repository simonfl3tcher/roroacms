//= require jquery
//= require jquery_ujs
//= require_tree .

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content"));
  }
});
