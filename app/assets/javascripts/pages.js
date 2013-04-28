/* You might have to redo this as you are only allowed on editable field on a page? */

function clickToEdit(){
	$('#editable_content').redactor({ focus: true });
	$('p.editable #editButton').hide();
	$('p.editable #saveButton').show();	
	
}
 
function clickToSave(){
	$('p.editable #editButton').show();
	$('p.editable #saveButton').hide();	
	// save content if you need
	var html = $('#editable_content').getCode();

	var data = {
	  id: $('#editable_content').attr('data-reference'),
	  html: html
	};

	// $.post('admin/posts/update_from_air', data, function(d){
 //      console.log(d)
 //    });

    $.ajax({ url: 'admin/posts/update_from_air',
	  type: 'POST',
	  beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
	  data: data,
	  success: function(response) {
	    console.log(response);
	  }
	});

	// destroy editor
	$('#editable_content').destroyEditor();	
}