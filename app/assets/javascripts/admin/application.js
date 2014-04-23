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
//= require jquery
//= require jquery_ujs
//= require jquery_ui.js
//= require dropzone.js
//= require scrolltop.js
//= require select.js
//= require sortable.js
//= require_tree .
//= require_directory .
//= require_self
//= require twitter/bootstrap

// // 
// $('#editButton').click(function(){
// 	clickToEdit();
// });

// setup ajax for crf-token needed by ruby
$.ajaxSetup({
	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
});