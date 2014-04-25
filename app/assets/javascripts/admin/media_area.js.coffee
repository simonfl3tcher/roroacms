$(document).ready ->
  
  # Media Library javascript 
  
  # General fucntions used by the above functionality 
  addActive = (opt) ->
    opt.parent("li").addClass("active").addClass "current"
    $(".fa-folder", opt).addClass "fa-folder-open"
    $(".fa-folder", opt).removeClass "fa-folder"
    return

  removeActive = (opt) ->
    opt.parent("li").removeClass "active"
    opt.parent("li").find("li.folderRow.active").each ->
      $(this).removeClass "active"
      $(".fa-folder-open", $(this)).addClass "fa-folder"
      $(".fa-folder-open", $(this)).removeClass "fa-folder-open"
      return

    $(".fa-folder-open", opt).addClass "fa-folder"
    $(".fa-folder-open", opt).removeClass "fa-folder-open"
    return

  spinner = (turnOff) ->
    if turnOff
      $(".loadingSpinner").css display: "none"
    else
      $(".loadingSpinner").fadeIn "slow"
    return

  reload_data = (opt) ->
    updateReference $(opt).attr("data-key")
    spinner()
    $.ajax
      type: "post"
      url: "/admin/media/get_via_ajax/"
      dataType: "html"
      data: "key=" + $(opt).attr("data-key")
      success: (data) ->
        $(".showFiles").html data
        spinner true
        return

    return

  updateReference = (key) ->
    key = ""  if key is "all"
    $("#bucketReference").attr "data-key", key
    reset_drop()
    return

  ammend_for_editing = (opt) ->
    start = opt.lastIndexOf("/")
    append = opt.substr(0, start + 1)
    edit = opt.substr(start + 1, opt.length)
    opt.replace edit, "<span class=\"editableArea\" data-keyrel=\"" + append + "\" data-current=\"" + opt + "\">" + edit + "</span>"
  
  getRef = ->
    $("#bucketReference").attr "data-key"
  
  getRefOrig = ->
    $("#bucketReference").attr "data-ref"
  
  reset_drop = ->
    myDropzone.options.params.reference = getRef()
    return
  
  updateFolderDisable = (opt) ->
    o = $("#bucketReference").attr("data-hasfolder", opt)
    if opt is "true"
      $("#create_dir").closest("form").css display: "none"
    else
      $("#create_dir").closest("form").css display: "block"
    return
  
  add_folder_into_top_tree = (selector, name, ref) ->
    selector.append "<li class=\"folderRow\"><a data-hasfolder=\"false\" data-key=\"" + getRefOrig() + name + "/\" href=\"\" class=\"folderLink\"><i class=\"fa fa-folder\"></i>&nbsp;<span>" + name + "</span><i class=\"fa fa-times\"></i></a></li>"
    spinner true
    return
  
  add_folder_into_tree = (selector, name, ref) ->
    selector.attr "data-hasfolder", true
    updateFolderDisable "true"
    selector.parent().append "<ul><li id=\"justAdded\" class=\"folderRow\"><a data-hasfolder=\"false\" data-key=\"" + ref + name + "/\" href=\"\" class=\"folderLink\"><i class=\"fa fa-folder\"></i>&nbsp;<span>" + name + "</span><i class=\"fa fa-times\"></i></a></li></ul>"
    spinner true
    return

  # This is to change the data that is displayed when clicking on different directories
  $(".leftMenu.mediaTypes").on "click", "a", (e) ->
    e.preventDefault()
    return

  $("body").on "click", ".overlay.general", (e) ->
    wrap = $(this).parent()
    $(".actions a:first .fa-eye", wrap).trigger "click"
    return

  $(".leftMenu.foldersMenu").on "click", "a", (e) ->
    e.preventDefault()
    $("li.folderRow.orange").removeClass "active"
    $("li.folderRow").removeClass "current"
    $(".rightMenu.active .fa-times-circle").trigger "click"  if $(".rightMenu.active").length > 0
    updateFolderDisable $(this).attr("data-hasfolder")
    if $(this).parent("li").hasClass("active")
      removeActive $(this)
    else
      addActive $(this)
      updateReference $(this).attr("data-key")
      spinner()
      $.ajax
        type: "post"
        url: "/admin/media/get_via_ajax/"
        dataType: "html"
        data: "key=" + $(this).attr("data-key")
        success: (data) ->
          $(".showFiles").html data
          spinner true
          return

    return

  $(".showFiles").on "click", ".fa-trash-o", (e) ->
    e.preventDefault()
    if confirm("Are you sure?")
      $(this).closest(".span3").children().fadeOut "slow"
      $(this).closest(".span3").fadeOut "slow"
      $.ajax
        type: "POST"
        data: "file=" + $(this).parent().attr("data-key")
        url: "/admin/media/delete_via_ajax/"
        dataType: "html"

    return

  # show file in full size 
  $(".showFiles").on "click", ".fa-eye", (e) ->
    e.preventDefault()
    $(".imageView").animate(
      left: "-=81.3%"
    , 458, "swing").addClass "active"
    $(".imageView .name").html ammend_for_editing($(this).parent().attr("data-key"))
    if $(this).attr("data-type-ref").indexOf("image/") isnt -1
      $(".showMisc").html "<img src=\"" + $(this).parent().attr("href") + "\" />"
    else
      $(".showMisc").html "<iframe style=\"width:100%; height:605px;\" src=\"" + $(this).parent().attr("href") + "\"></iframe>"
    return

  $(".imageView").on "click", ".fa-times-circle", (e) ->
    e.preventDefault()
    reload_data ".leftMenu.foldersMenu .folderRow.current a"
    $(".imageView").animate(
      left: "+=81.3%"
    , 458, "swing").removeClass "active"
    setTimeout (->
      $(".showMisc").html " "
      return
    ), 500
    return

  # show multiple file upload area
  $(".rightMenu").on "click", "#fileUploadActivator", (e) ->
    e.preventDefault()
    $(".fileUpload").animate(
      left: "-=81.3%"
    , 458, "swing").addClass "active"
    return

  $(".fileUpload").on "click", ".fa-times-circle", (e) ->
    e.preventDefault()
    reload_data ".leftMenu.foldersMenu .folderRow.current a"
    $(".fileUpload").animate(
      left: "+=81.3%"
    , 458, "swing").removeClass "active"
    setTimeout (->
      $(".showFileUpload #my-awesome-dropzone").html " "
      return
    ), 500
    return

  # Hide and show the remove directory Icons 
  $(".leftMenu.foldersMenu").on
    mouseenter: (e) ->
      $("i.fa-times", $(this)).stop(true, true).fadeIn().addClass "active"
      return

    mouseleave: (e) ->
      $("i.fa-times", $(this)).stop(true, true).fadeOut().removeClass "active"
      return
  , "a"

  # remove option from media area and s3
  $(".leftMenu.foldersMenu").on "click", "i.fa-times", (e) ->
    e.preventDefault()
    li = $(this).closest("li")
    key = $("a", li).attr("data-key")
    selector = $("a", li.parent().parent())
    selector.attr "data-hasfolder", "false"
    li.slideUp()
    reload_data selector
    # do ajax call
    setTimeout (->
      li.remove()
      selector.closest("li").addClass "current"
      $.ajax
        type: "POST"
        data: "file=" + key
        url: "/admin/media/delete_via_ajax/"
        dataType: "html"

      return
    ), 500
    return

  # create folder
  $(".addFolder").bind "submit", (e) ->
    e.preventDefault()
    name = $("#create_dir", $(this)).val()
    spinner()
    dir = getRef() + name
    select = $("#folderList li a[data-key=\"" + getRef() + "\"]")
    $.ajax
      type: "POST"
      url: "/admin/media"
      data: "create_dir=" + dir
      dataType: "html"
      success: (e) ->
        if not select.length is 0
          add_folder_into_tree select, name, getRef()
          $("#justAdded a").trigger("click").parent().removeAttr "id"
        else
          add_folder_into_top_tree $("#folderList"), name, getRef()
        $("#create_dir").val ""
        return

    return

  if $("#my-awesome-dropzone").length > 0
    myDropzone = new Dropzone("#my-awesome-dropzone",
      thumbnailWidth: 219
      thumbnailHeight: 140
      params:
        reference: getRef()

      url: "/admin/media/multipleupload"
      success: (file, response) ->
        if response.code is 501
          # succeeded
          file.previewElement.classList.add "dz-success"
        else if response.code is 403
          node = undefined
          _i = undefined
          _len = undefined
          _ref = undefined
          _results = undefined
          message = response.msg # modify it to your error message
          file.previewElement.classList.add "dz-error"
          _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]")
          _results = []
          _i = 0
          _len = _ref.length

          while _i < _len
            node = _ref[_i]
            _results.push node.textContent = message
            _i++
          _results
    )

  $(".pull-left .name").on "click", ".editableArea:not(.active)", (e) ->
    $(this).addClass "active"
    $(this).html "<input name=\"task[" + $(this).text().replace(" ", "") + "]\" id=\"editbox\" size=\"" + $(this).text().length + "\" value=\"" + $(this).text() + "\" type=\"text\">"
    return

  $(".pull-left .name ").on "keypress", "input", (e) ->
    if e.which is 13 and not e.shiftKey
      # do ajax call
      if $(this).val().indexOf(".") isnt -1 and $(this).val() isnt ""
        n = $(this).closest(".editableArea").attr("data-keyrel") + $(this).val()
        p = $(this).closest(".editableArea").attr("data-current")
        $(this).closest(".editableArea").removeClass("active").html $(this).val()
        $.ajax
          type: "POST"
          url: "/admin/media/rename_media"
          data: "new=" + n + "&previous=" + p
          dataType: "html"

      else
        $(this).addClass "error"
    return

  $(window).load ->
    $(".leftMenu.foldersMenu .folderRow.initial a").trigger("click").parent().removeClass("initial").delay "1000"
    return

  return
