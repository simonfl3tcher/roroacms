$(document).ready ->
  $("#term_name").bind "change keyup", ->
    $("#term_slug").val $(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-")
    return

  
  # submit the closest form on click of the updatepost class
  $(".updatepost").bind "click", (e) ->
    $("body").find("form").submit()
    e.preventDefault()
    return

  
  # This is the ajax call for the autosave when on pages 
  if $("#post_post_title").length > 0
    setInterval (->
      unless $("#post_post_title").val() is ""
        form = $("form")
        method = form.attr("method").toLowerCase() # "get" or "post"
        action = form.attr("action")
        formData = form.serialize()
        for instance of CKEDITOR.instances
          c = CKEDITOR.instances[instance].getData()
        formData += "&ck_content=" + encodeURIComponent(c)
        if $("input[name=\"_method\"]").length > 0
          $.post "/admin/posts/autosave_update", formData, (data) ->
            $("#revisionsContainer").html data
            return

      return
    ), 120000
  
  # check all the closest checkboxes - used for the bulk update in the admin panel
  $(".checkall").change ->
    checkboxes = $(this).closest("form").find(":checkbox")
    checkboxes.attr "checked", $(this).is(":checked")
    return

  
  # URL writer when writing the title of the page 
  $("#post_post_title").bind "change keyup", (->
    $("#post_post_slug").val $(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-")
    return
  )
  
  # Select2 options
  $("select").select2
    placeholder: "Please select"
    allowClear: true

  $.scrollUp()
  return

