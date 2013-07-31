$(document).ready(function(){

	$('ol.sortable').nestedSortable({
		items: 'li',
		maxLevels:3,
		update: function(){
			do_update_function()
		}
	});

	$('.updateMenu').bind('click', function(e){
		do_update_function()
		do_alert()
	});

	function do_update_function(){
		var arr = $('ol.sortable').nestedSortable('toArray');
		data = 'data=' + JSON.stringify(arr) + '&menuid=' + $('ol.sortable').attr('data-menuid')
		 $.ajax({
		      type: "POST",
		      url: '/admin/menus/save_menu',
		      data: data,
		      dataType: "html",
		      success: function(data){
		      	
		      }
		  });
	}


	function do_alert(){
		$('#content .container h2').before('<div class="alert alert-success"><button data-dismiss="alert" class="close" type="button">x</button><strong>Success!</strong> Menu was successfully updated.</div>')
		$('html,body').animate({
            scrollTop: $("#header").offset().top
        }, 'slow');
	}

	$('ol.sortable').on('click', 'i.handler', function(){
		
		container = $(' > .itemInformation', $(this).closest('li'));

		if (container.hasClass('active')){

			$(this).removeClass('icon-minus-sign');
			$(this).addClass('icon-plus-sign');


			container.slideUp('slow');
			container.removeClass('active')

		} else {
			$(this).removeClass('icon-plus-sign');
			$(this).addClass('icon-minus-sign');

			container.slideDown('slow');
			container.addClass('active')

		}
	})


	$('select.mod').bind('change', function(e){
		form = $(this).closest("form");
		$('input[name="type"]', form).val($(':selected',$(this)).attr('data-type'));
		$('input[name=label]', form).val($(':selected',$(this)).text());
	})


	$('.span3 form').bind('submit', function(e){
		e.preventDefault();
		var type = $(this).attr('data-type')
		data = $(this).serializeArray();
		dataString = $(this).serialize();

		if(data[2]['value'] == ''){
			label = ''
		} else {
			label = data[2]['value']
		}

		var randomnumber = Math.floor(Math.random()*11)
		if(type == 'custom'){
			if(($('input[name=customlink]', $(this)).val() != '') && ($('input[name=label]', $(this)).val() != '')){
				html = '<li class="" style="" data-id="option_' + data[1]['value'] + '" id="custom_' + randomnumber + '" data-type="custom" data-data="' + dataString + '"><div>' + label + '<i class="icon-plus-sign pull-right handler"></i></div>'
				$('ol.sortable').append(html);
				build_under_form(data, '#custom_' + randomnumber)
			}
		} else {
			if(($('select[name=linkto]', $(this)).val() != '') && ($('input[name=label]', $(this)).val() != '')){
				formData = $(this).serialize();
				html = '<li class="" style="" data-id="option_' + data[1]['value'] + '" id="' + data[0]['value'] + '_' + randomnumber +'" data-type="' + data[0]['value']  + '" data-data="' + dataString + '"><div>' + label + '<i class="icon-plus-sign pull-right handler"></i></div>'
				$('ol.sortable').append(html);
				build_under_form(data,  '#' +  data[0]['value'] + '_' + randomnumber)
			}
		}

	});

	$('ol.sortable').on('click', '.submitForm', function(){
		$(this).closest('li').attr('data-data', $(this).closest('form').serialize())
		$('.updateMenu').trigger('click')
	})

	$('.span9').on('submit', 'form', function(e){
		e.preventDefault();
		dataString = $(this).serialize();
		parent = $(this).closest('li');
		$(parent).attr('data-data', dataString);
		$('#updateMenu').trigger('click')
	});	

	$('.span9').on('click', '.deleteOption', function(e){
		e.preventDefault();
		$(this).closest('.itemInformation').slideUp('slow')
		li = $(this).closest('li').fadeOut('slow');
		setTimeout(function(e){
			$(li).remove();
		}, 1000)
	});


	var addingData = ''

	function build_under_form(data, selector){			
		$.ajax({
		  type: "POST",
		  url: '/admin/menus/ajax_dropbox',
		  data: data,
		  dataType: "html",
		  success: function(data){
		  	populate(data, selector)
		  }
		});
	}

	function populate(d, selector){
		$(selector).append(d)
	}

});