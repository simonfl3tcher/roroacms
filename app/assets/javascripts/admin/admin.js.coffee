$(document).ready ->
  
  # RoxyFileBrowser = (field_name, url, type, win) ->
  #   roxyFileman = "/fileman/index.html"
  #   if roxyFileman.indexOf("?") < 0
  #     roxyFileman += "?type=" + type
  #   else
  #     roxyFileman += "&type=" + type
  #   roxyFileman += "&input=" + field_name + "&value=" + document.getElementById(field_name).value
  #   tinyMCE.activeEditor.windowManager.open
  #     file: roxyFileman
  #     title: "Roxy Fileman"
  #     width: 850
  #     height: 1000
  #     resizable: "yes"
  #     plugins: "media"
  #     inline: "yes"
  #     close_previous: "no"
  #   ,
  #     window: win
  #     input: field_name

  #   false

  tinymce.init
    selector: ".editor"
    plugins: "fullscreen, image, code, table, link, media"
    tools: "inserttable"
    toolbar1: "bold,italic,strikethrough,bullist,numlist,blockquote,hr,alignleft,aligncenter,alignright,link,unlink,image,code,table,fullscreen"
    toolbar2: "formatselect,underline,alignjustify,forecolor,pastetext,removeformat,outdent,indent,undo,redo,spellchecker"
    tabfocus_elements: "insert-media-button,save-post"
    add_unload_trigger: false
    menubar: false

  settings = $('.js-settings')
  $("#term_name").bind "change keyup", ->
    if $("#term_id").val() == ''
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
        form = $("form :input[name!='utf8'][name!='_method'][name!='authenticity_token']")
        $('#post_post_content').val(tinymce.get('post_post_content').getContent())
        formData = form.serialize()
        if $("input[name=\"_method\"]").length > 0
          $.ajax
            type: "POST"
            url: "/admin/articles/autosave"
            data: formData 
            success: (data) ->
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
  $("#post_post_title").bind "change keyup", ->
    if $("#post_id").val() == ''
      $("#post_post_slug").val $(this).val().replace(/[^a-zA-Z0-9 -]/g, "").toLowerCase().split(" ").join("-")
      return

  $(".chosen-select").chosen({width: "100%", placeholder_text_multiple: I18n.t('javascript.admin.chosen.placeholder')})

  content = $("#post_post_content").html()
  $("[rel='tooltip']").tooltip();

  dTable = $("#dtable").dataTable
    bLengthChange: false
    bInfo: false
    iDisplayLength: parseInt(settings.attr('data-pagination-limit'))
    oLanguage:
      sSearch: ""
      sEmptyTable: "There are currently no records!"

    bSort: false
    fnInitComplete: (oSettings, json) ->
      $("#dtable_paginate").detach().prependTo "#paginationWrapper"
      return

  $("#tableFilter").keyup ->
    dTable.fnFilter $(this).val()
    return

  return