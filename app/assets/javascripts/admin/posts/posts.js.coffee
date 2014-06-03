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
  $("body").on "click", ".add-article-image", (e) ->
    e.preventDefault()
    $('#post-post-image').trigger('click');
    return

  $("#post-post-image").change ->
    readURL this
    return


  $("body").on "click", ".add-profile-image", (e) ->
    e.preventDefault()
    $('#admin-cover-picture').trigger('click');
    return

  $("#admin-cover-picture").change ->
    readURL this
    $('.add-profile-image').addClass('hidden')
    $('.remove-profile-image').removeClass('hidden')
    return

  $("body").on "click", ".remove-profile-image", (e) ->
    
    input = $("#admin-cover-picture")

    $(".well").attr("style", "")
    $(this).addClass('hidden')
    $('.add-profile-image').removeClass('hidden')
    $(".well input[name=has_cover_image]").val('')

    input.replaceWith(input.val('').clone(true))
    return

  $("body").on "keypress", "#addAdditionalDataInput", (e) ->
    $("#addAdditionalDataInput").val $("#addAdditionalDataInput").val().toLowerCase().replace(" ", "-").replace(/[^a-zA-Z0-9_-]/g,'')
    if e.which is 13
      e.preventDefault()
      $(".addAdditionalDataInput").trigger "click"
    return

  $("body").on "click", ".addAdditionalDataInput", ->
    $.ajax
      type: "POST"
      url: "/admin/articles/create_additional_data"
      data: "key=" + $("#addAdditionalDataInput").val()
      dataType: "html"
      success: (data) ->
        $(".additionalDataOptions").append data
        $("#addAdditionalDataInput").val ""
        return

    return

  $("body").on "click", ".remove-additional-group", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").remove()  if confirm( I18n.t('javascript.posts.are_you_sure') )
    return

  return