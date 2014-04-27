# Activates the Carousel
$(".carousel").carousel interval: 5000

# Activates Tooltips for Social Links
$(".tooltip-social").tooltip selector: "a[data-toggle=tooltip]"

# reply button on the news comment area
$(document).ready ->
  $(".reply").click ->
    $("#comment_comment_parent").val $(this).attr("data-parent")
    $("#replyToTitle").html "Reply To:- " + $(this).parent().find(".comment-meta").attr("data-author")
    $("html,body").animate
      scrollTop: ($("fieldset.commentForm").offset().top - 150)
    , "slow"
    return

  return