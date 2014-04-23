$(document).ready(function(){
	
	$("#term_name").bind('change keyup', function(){
	    $("#term_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, '').toLowerCase().split(' ').join('-'));
	});

	// submit the closest form on click of the updatepost class

	$('.updatepost').bind('click', function(e){
      $('body').find('form').submit();
      e.preventDefault();
    });	

    /* This is the ajax call for the autosave when on pages */
    if($('#post_post_title').length > 0){
	    setInterval(function(){
	      if($('#post_post_title').val() != ""){
	        var form = $('form');
	        var method = form.attr('method').toLowerCase();      // "get" or "post"
	        var action = form.attr('action');  
	        var formData = form.serialize();
	         for (instance in CKEDITOR.instances){
	          var c = CKEDITOR.instances[instance].getData();
	        }
	        formData += "&ck_content=" + encodeURIComponent(c);
	         if($('input[name="_method"]').length > 0){  
	            $.post('/admin/posts/autosave_update', formData, function(data){
	              $('#revisionsContainer').html(data)
	            });
	          } 
	        }
	    }, 120000);
	}

	// check all the closest checkboxes - used for the bulk update in the admin panel

	$('.checkall').change(function() {
	  var checkboxes = $(this).closest('form').find(':checkbox');
	  checkboxes.attr('checked', $(this).is(':checked'));
	});

    /* URL writer when writing the title of the page */

    $("#post_post_title").bind('change keyup', (function(){
        $("#post_post_slug").val($(this).val().replace(/[^a-zA-Z0-9 -]/g, '').toLowerCase().split(' ').join('-'));
    });

    // Select2 options

	$("select").select2({ placeholder: "Please select"	, allowClear: true});

	$.scrollUp();
 

});