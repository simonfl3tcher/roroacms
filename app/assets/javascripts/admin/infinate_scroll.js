// $(document).ready(function(){
// 	$(window).scroll(function()
// 	{
// 	    if($(window).scrollTop() == $(document).height() - $(window).height())
// 	    {
// 	        $('div#loadmoreajaxloader').show();
// 	        $.ajax({
// 			type: "POST",
// 	        url: "/admin/pages/infinate_scroll/",
// 			data: 'offset=' + $('.table').attr('data-offset'),
// 	        success: function(html)
// 	        {
// 	            if(html)
// 	            {
// 					$('.table').attr('data-offset', parseInt($('.table').attr('data-offset')) + 10)
// 	                $(".table tbody").append(html);
// 	                $('div#loadmoreajaxloader').hide();
// 	            }else
// 	            {
// 	                $('div#loadmoreajaxloader').html('<center>No more records.</center>');
// 	            }
// 	        }
// 	        });
// 	    }
// 	});
// });