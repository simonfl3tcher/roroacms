readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      $(".well").css({ 
        'background-position': 'center center', 
        'background-image': 'url(' + e.target.result + ')',
        'background-repeat': 'no-repeat',
        'background-size': 'cover',
        'overflow': 'hidden'
      })
      return

    reader.readAsDataURL input.files[0]
  return

$(document).ready ->
  $("body").on "click", ".addArticleImage", (e) ->
    e.preventDefault()
    $('#post_post_image').trigger('click');
    return

  $("#post_post_image").change ->
    readURL this
    return

  return
