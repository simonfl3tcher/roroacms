popitup = ->
  left = (screen.width / 2) - (1137 / 2)
  top = (screen.height / 2) - (600 / 2)
  newwindow = window.open(base_url("/admin/media/?manualBrowse=true"), "name", "height=600,width=1137,scrollbars=yes,top=" + top + ",left=" + left)
  newwindow.focus()  if window.focus
  false
  
returnImageFunction = (image) ->
  $("#post_post_image").val image
  $(".imagePlaceholder").html "<img src=\"" + image + "\"/>"
  $(".imagePlaceholder").append "<a href=\"javascript:;\" class=\"removeArticleImage\"><i class=\"icon-remove\"></i>&nbsp;Remove Article Image</a>"
  return

removeFeaturedImage = ->
  $("#post_post_image").val ""
  $(".imagePlaceholder").html "<a href=\"javascript:;\" id=\"filebrowser\" class=\"addArticleImage\"><i class=\"icon-plus\"></i>&nbsp;Add Article Image</a>"
  return

$(document).ready ->
  $("body").on "click", ".addArticleImage", (e) ->
    e.preventDefault()
    popitup()
    return

  $("body").on "click", ".removeArticleImage", ->
    removeFeaturedImage()
    return

  return
