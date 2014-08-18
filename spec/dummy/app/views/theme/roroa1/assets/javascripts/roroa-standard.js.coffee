$(document).ready ->
  $(".reply").click ->
    $("#comment_comment_parent").val $(this).attr("data-parent")
    $("#replyToTitle").html "Reply To:- " + $(this).parent().find(".comment-meta").attr("data-author")
    $("html,body").animate
      scrollTop: $("fieldset.commentForm").offset().top
    , "slow"
    return

  return
