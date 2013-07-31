$(document).ready(function(){
	
	/* This is to change the data that is displayed when clicking on different directories */
	$('.leftMenu.mediaTypes').on('click', 'a', function(e){
		e.preventDefault();
	});

	$('body').on('click', '.overlay.general', function(e){
		var wrap = $(this).parent();
		$('.actions a:first .icon-eye-open', wrap).trigger('click');
	});

	$('.leftMenu.foldersMenu').on('click', 'a', function(e){
		e.preventDefault();		
		$('li.folderRow').removeClass('current')
		
		if($('.rightMenu.active').length > 0) {
			$('.rightMenu.active .icon-remove-sign').trigger('click');
		}
		
		updateFolderDisable($(this).attr('data-hasfolder'))
		if($(this).parent('li').hasClass('active')){
			removeActive($(this))
		} else {
			addActive($(this))
			updateReference($(this).attr('data-key'))
			spinner();
			$.ajax({
			      type: "post",
			      url: '/admin/media/get_via_ajax/',
			      dataType: "html",
			      data: 'key=' + $(this).attr('data-key'),
			      success:function(data){
			      	$('.showFiles').html(data);
			      	spinner(true);
			      }
			  });		
		}

	});

	$('.showFiles').on('click', '.icon-trash', function(e){
		e.preventDefault();
		if(confirm('Are you sure?')){
			$(this).closest('.span3').children().fadeOut('slow')
			$(this).closest('.span3').fadeOut('slow')
			$.ajax({
					type: "POST",
					data: 'file=' + $(this).parent().attr('data-key'),
					url: '/admin/media/delete_via_ajax/',
					dataType: "html"
			  });
		} 
	})

	/* show file in full size */

	$('.showFiles').on('click', '.icon-eye-open', function(e){
		e.preventDefault();
		$('.imageView').animate({left: '-=62.3%'}, 458, 'swing').addClass('active')
		$('.imageView .name').html(ammend_for_editing($(this).parent().attr('data-key')))
		$('.showMisc').html('<img src="' + $(this).parent().attr('href') + '" />');
	});
	
	$('.imageView').on('click', '.icon-remove-sign', function(e){
		e.preventDefault();
		reload_data('.leftMenu.foldersMenu .folderRow.current a')
		$('.imageView').animate({left: '+=62.3%'}, 458, 'swing').removeClass('active')
		setTimeout(function(){
			$('.showMisc').html(' ');
		}, 500);
	});

	/* show multiple file upload area */

	$('.rightMenu').on('click', '#fileUploadActivator', function(e){
		e.preventDefault();
		$('.fileUpload').animate({left: '-=62.3%'}, 458, 'swing').addClass('active')
	});
	
	$('.fileUpload').on('click', '.icon-remove-sign', function(e){
		e.preventDefault();
		reload_data('.leftMenu.foldersMenu .folderRow.current a')
		$('.fileUpload').animate({left: '+=62.3%'}, 458, 'swing').removeClass('active')
		setTimeout(function(){
			$('.showFileUpload #my-awesome-dropzone').html(' ');
		}, 500);
	});

	/* Hide and show the remove directory Icons */

	$('.leftMenu.foldersMenu').on({
	  mouseenter: function(e) {
	   $('i.icon-remove', $(this)).stop(true, true).fadeIn().addClass('active');
	  },
	  mouseleave: function(e) {
	   $('i.icon-remove', $(this)).stop(true, true).fadeOut().removeClass('active')
	  }
	}, 'a');


	/* remove option from media area and s3 */

	$('.leftMenu.foldersMenu').on('click', 'i.icon-remove', function(e){
		e.preventDefault();
		 var li = $(this).closest('li');
		 var key = $('a', li).attr('data-key');
		 var selector = $('a', li.parent().parent())
		 li.slideUp();
		 reload_data(selector)
		 setTimeout(function(){
		 	li.remove();
		 	$.ajax({
		       type: "POST",
		       data: 'file=' + key,
		       url: '/admin/media/delete_via_ajax/',
		       dataType: "html"
		   });
		 }, 500)
	})

	/* create folder */

	$('.addFolder').bind('submit', function(e){
		e.preventDefault();
		var name = $('#create_dir', $(this)).val()
		spinner();
		var dir = getRef() + name
		var select = $('#folderList li a[data-key="' + getRef() + '"]')

		$.ajax({
		      type: "POST",
		      url: '/admin/media',
		      data: 'create_dir=' + dir,
		      dataType: "html",
		      success:function(e){
		      	if(!select.length == 0){
		      		add_folder_into_tree(select, name, getRef());
		      	} else {
		      		add_folder_into_top_tree($('#folderList'), name, getRef());
		      	}
		      }
		  });

	});

	if($('#my-awesome-dropzone').length > 0){
		console.log(getRef())
		var myDropzone = new Dropzone("#my-awesome-dropzone", {
			thumbnailWidth: 219, 
			thumbnailHeight:140,
			params: {reference: getRef()}, 
			url: '/admin/media/multipleupload'
		});
	}

	$('.pull-left .name').on('click', '.editableArea:not(.active)', function(e){
		$(this).addClass('active')
		$(this).html('<input name="task[' + $(this).text().replace(' ', '') +  ']" id="editbox" size="'+$(this).text().length+'" value="' + $(this).text()+'" type="text">'); 
	});

	$('.pull-left .name ').on('keypress', 'input', function(e){
		if(e.which == 13 && !e.shiftKey){
			// do ajax call buds
			if($(this).val().indexOf('.') !== -1 && $(this).val() != ''){
				var n = $(this).closest('.editableArea').attr('data-keyrel') + $(this).val()
				var p = $(this).closest('.editableArea').attr('data-current')
				$(this).closest('.editableArea').removeClass('active').html($(this).val())
				$.ajax({
			      type: "POST",
			      url: '/admin/media/rename_media',
			      data: 'new=' + n + '&previous=' + p,
			      dataType: "html"
			  });
			} else {
				$(this).addClass('error')
			}
		}
	});

	$(window).load(function () {
		$('.leftMenu.foldersMenu .folderRow.initial a').trigger('click').parent().removeClass('initial').delay('1000');
	});

	function addActive(opt){
		opt.parent('li').addClass('active').addClass('current')
		$('.icon-folder-close', opt).addClass('icon-folder-open')
		$('.icon-folder-close', opt).removeClass('icon-folder-close')
	}

	function removeActive(opt){
		opt.parent('li').removeClass('active')
		opt.parent('li').find('li.folderRow.active').each(function(){
			$(this).removeClass('active')
			$('.icon-folder-open', $(this)).addClass('icon-folder-close')
			$('.icon-folder-open', $(this)).removeClass('icon-folder-open')
		})
		$('.icon-folder-open', opt).addClass('icon-folder-close')
		$('.icon-folder-open', opt).removeClass('icon-folder-open')
	}

	function spinner(turnOff){
		if(turnOff){
			$('.loadingSpinner').css({display: 'none'});
		} else {
			$('.loadingSpinner').fadeIn('slow');
		}
	}


	function reload_data(opt){
		updateReference($(opt).attr('data-key'))
		spinner();
		$.ajax({
		      type: "post",
		      url: '/admin/media/get_via_ajax/',
		      dataType: "html",
		      data: 'key=' + $(opt).attr('data-key'),
		      success:function(data){2
		      	$('.showFiles').html(data);
		      	spinner(true);
		      }
		  });	
	}

	function updateReference(key){
		if(key == 'all'){
			key = ''
		}
		$('#bucketReference').attr('data-key', key)
		reset_drop()
	}

	function ammend_for_editing(opt){
		start = opt.lastIndexOf("/");
		append = opt.substr(0, start+1)
		edit = opt.substr(start +1, opt.length)


		return opt.replace(edit, '<span class="editableArea" data-keyrel="' + append + '" data-current="' + opt + '">' + edit + '</span>')  
	}

	function getRef(){
		return $('#bucketReference').attr('data-key')
	}

	function reset_drop(){
		myDropzone.options.params.reference = getRef()
	}

	function updateFolderDisable(opt){
		var o = $('#bucketReference').attr('data-hasfolder', opt)

		if(opt == 'true'){
			$('#create_dir').closest('form').css({display: 'none'});
		} else {
			$('#create_dir').closest('form').css({display: 'block'});
		}
	}

	function add_folder_into_top_tree(selector, name, ref){
		selector.append('<li class="folderRow"><a data-hasfolder="false" data-key="' + ref + name + '/" href="" class="folderLink"><i class="icon-folder-close"></i>&nbsp;<span>' + name + '</span><i class="icon-remove"></i></a></li>');
		spinner(true);

	}


	function add_folder_into_tree(selector, name, ref){
		selector.parent().append('<ul><li class="folderRow"><a data-hasfolder="false" data-key="' + ref + name + '/" href="" class="folderLink"><i class="icon-folder-close"></i>&nbsp;<span>' + name + '</span><i class="icon-remove"></i></a></li></ul>');
		spinner(true);

	}


});