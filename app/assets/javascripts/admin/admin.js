$(document).ready(function(){
	
	$("#term_name").keyup(function(){
	    $("#term_slug").val($(this).val().toLowerCase().split(' ').join('-'));
	});

	$("#term_name").change(function(){
		$("#term_slug").val($(this).val().toLowerCase().split(' ').join('-'));
	});

	$('.updatepost').bind('click', function(e){
      $('body').find('form').submit();
      e.preventDefault();
    });	
    
})