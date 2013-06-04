// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require_self
//= require jquery
//= require jquery-ui
//= require jquery-1.9.0
//= require ckeditor-jquery
//= require twitter/bootstrap

$('.checkall').change(function() {
  var checkboxes = $(this).closest('form').find(':checkbox');
  checkboxes.attr('checked', $(this).is(':checked'));
});
3
$('#editButton').click(function(){
	clickToEdit();
});

$.ajaxSetup({
	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
});