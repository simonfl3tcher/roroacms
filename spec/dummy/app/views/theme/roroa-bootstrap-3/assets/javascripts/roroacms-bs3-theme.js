$(".carousel").carousel({
  interval: 5000
});

$(".tooltip-social").tooltip({
  selector: "a[data-toggle=tooltip]"
});

$(document).ready(function() {
  $(".reply").click(function() {
    $("#comment_comment_parent").val($(this).attr("data-parent"));
    $("#replyToTitle").html("Reply To:- " + $(this).parent().find(".comment-meta").attr("data-author"));
    $("html,body").animate({
      scrollTop: $("fieldset.commentForm").offset().top - 150
    }, "slow");
  });
});
