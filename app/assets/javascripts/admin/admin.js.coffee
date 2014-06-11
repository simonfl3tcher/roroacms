$(document).ready ->
  settings = $('.js-settings')
  $("#term_name").bind "change keyup", ->
    $("#term_slug").val $(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-")
    return

  $("#menu_name").bind "change keyup", ->
    $("#menu_key").val $(this).val().toLowerCase().split(" ").join("-")
    return

  $(".checkall").change ->
    checkboxes = $(this).closest("form").find(":checkbox")
    checkboxes.attr "checked", $(this).is(":checked")
    return

  $.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
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
          $.post "/admin/articles/autosave_update", formData, (data) ->
            if data != 'f'
              $("#revisionsContainer, #revisions").html data
              return

      return
    ), 120000
  
  # check all the closest checkboxes - used for the bulk update in the admin panel
  $("body").on 'ifChecked ifUnchecked', 'th #check_all', (event) ->
    if (event.type == 'ifChecked')
      $('tbody td input[type=checkbox]').iCheck('check');
    else
      $('tbody td input[type=checkbox]').iCheck('uncheck');
    return
  
  # URL writer when writing the title of the page 
  $("#post_post_title").bind "change keyup", (->
    $("#post_post_slug").val $(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-")
    return
  )

  $(".chosen-select").chosen({width: "100%", placeholder_text_multiple: I18n.t('javascript.admin.chosen.placeholder')})

  content = $("#post_post_content").html()
  $(".editor").ghostDown();
  $('.CodeMirror-code').html('<pre>' + content + '</pre>')
  $("[rel='tooltip']").tooltip();

  dTable = $("#dtable").dataTable
    bLengthChange: false
    bInfo: false
    iDisplayLength: parseInt(settings.attr('data-pagination-limit'))
    oLanguage:
      sSearch: ""
      sEmptyTable: "You have no comments!"

    bSort: false
    fnInitComplete: (oSettings, json) ->
      $("#dtable_paginate").detach().prependTo "#paginationWrapper"
      return

  $("#tableFilter").keyup ->
    dTable.fnFilter $(this).val()
    return

  return