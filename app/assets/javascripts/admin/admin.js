$(document).ready(function(){
	
	$("#term_name").keyup(function(){
	    $("#term_slug").val($(this).val().replace(/\W/g, '').toLowerCase().split(' ').join('-'));
	});

	$("#term_name").change(function(){
		$("#term_slug").val($(this).val().replace(/\W/g, '').toLowerCase().split(' ').join('-'));
	});

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
	    }, 10000);
	}

    /* URL writer when writing the title of the page */

    $("#post_post_title").keyup(function(){
        $("#post_post_slug").val($(this).val().replace(/\W/g, '').toLowerCase().split(' ').join('-'));
    });

    $("#post_post_title").change(function(){
        $("#post_post_slug").val($(this).val().replace(/\W/g, '').toLowerCase().split(' ').join('-'));
    });

	$("select").select2({ placeholder: "Please select"	, allowClear: true});

	$.scrollUp();

	// $('#main-nav li a').tooltip({placement: 'bottom'})
 

})