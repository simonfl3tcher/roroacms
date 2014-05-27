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
      $(".well input[name=has_cover_image]").val("Y")
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


  $("body").on "click", ".addProfileImage", (e) ->
    e.preventDefault()
    $('#admin_cover_picture').trigger('click');
    return

  $("#admin_cover_picture").change ->
    readURL this
    $('.addProfileImage').addClass('hidden')
    $('.removeProfileImage').removeClass('hidden')
    return

  $("body").on "click", ".removeProfileImage", (e) ->
    
    input = $("#admin_cover_picture")

    $(".well").attr("style", "")
    $(this).addClass('hidden')
    $('.addProfileImage').removeClass('hidden')
    $(".well input[name=has_cover_image]").val('')

    input.replaceWith(input.val('').clone(true))
    return

  $("body").on "keypress", "#addAdditionalDataInput", (e) ->
    $("#addAdditionalDataInput").val $("#addAdditionalDataInput").val().toLowerCase().replace(" ", "-")
    if e.which is 13
      e.preventDefault()
      $(".addAdditionalDataInput").trigger "click"
    return

  $("body").on "click", ".addAdditionalDataInput", ->
    $.ajax
      type: "POST"
      url: "/admin/posts/create_additional_data"
      data: "key=" + $("#addAdditionalDataInput").val()
      dataType: "html"
      success: (data) ->
        $(".additionalDataOptions").append data
        $("#addAdditionalDataInput").val ""
        return

    return

  $("body").on "click", ".removeAdditionalGroup", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").remove()  if confirm("Are you sure?")
    return

  return