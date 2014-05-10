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
//= require ckeditor-jquery
//= require ../../../../vendor/assets/javascripts/admin/jquery-1.10.2.min.js
//= require ../../../../vendor/assets/javascripts/admin/jquery-ui-1.10.4.min.js
//= require ../../../../vendor/assets/javascripts/admin/datatables/js/jquery.datatables.js
//= require ../../../../vendor/assets/javascripts/admin/datatables/js/datatables.bootstrap.js
//= require_tree ../../../../vendor/assets/javascripts/admin
//= require_tree .
//= require_directory .
//= require_self

$('.checkall').change(function() {
  var checkboxes = $(this).closest('form').find(':checkbox');
  checkboxes.attr('checked', $(this).is(':checked'));
});

$('#editButton').click(function(){
	clickToEdit();
});

$.ajaxSetup({
	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
});


$("#term_name").keyup(function(){
    $("#term_slug").val($(this).val().toLowerCase().split(' ').join('-'));
});

$("#term_name").change(function(){
	$("#term_slug").val($(this).val().toLowerCase().split(' ').join('-'));
});
