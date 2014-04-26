// Activates the Carousel
$('.carousel').carousel({
  interval: 5000
})

// Activates Tooltips for Social Links
$('.tooltip-social').tooltip({
  selector: "a[data-toggle=tooltip]"
});

$('.reply').click(function(e){
	e.preventDefault();
	console.log('123123')
	$("#comment_comment_parent").val($(this).attr("data-parent"));
	$("#replyToTitle").html("Reply To:- " + $(this).parent().find(".comment-meta").attr("data-author"));
    $('html,body').animate({
        scrollTop: $("fieldset.new_comment").offset().top
    }, 'slow');
});