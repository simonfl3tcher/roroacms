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
    $('#post_post_image').trigger('click');
    return

  $("body").on "click", ".add-term-image", (e) ->
    e.preventDefault()
    $('#term_cover_image').trigger('click');
    return

  $("#post_post_image").change ->
    readURL this
    $('.add-article-image').addClass('hidden')
    $('.remove-profile-image').removeClass('hidden')
    return


  $("body").on "click", ".add-profile-image", (e) ->
    e.preventDefault()
    $('#admin_cover_picture').trigger('click');
    return

  $("#admin_cover_picture").change ->
    readURL this
    $('.add-profile-image').addClass('hidden')
    $('.remove-profile-image').removeClass('hidden')
    return

  $("body").on "click", ".remove-profile-image", (e) ->
    
    input = $("#admin_cover_picture")

    $(".well").attr("style", "")
    $(this).addClass('hidden')
    $('.add-profile-image').removeClass('hidden')
    $('.add-article-image').removeClass('hidden')
    $('.add-term-image').removeClass('hidden')
    $(".well input[name=has_cover_image]").val('')

    input.replaceWith(input.val('').clone(true))
    return

  $("#term_cover_image").change ->
    readURL this
    $('.add-term-image').addClass('hidden')
    $('.remove-profile-image').removeClass('hidden')
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