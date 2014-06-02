responsive_app = do ->
  init = ->
    respond()
    return

  respond = ->
    if $(window).width() < 768
      $(".settings-area .nav-tabs a:not([data-textref])").each ->
        text = $(this).text().replace(" ", "")
        $(this).attr "data-textref", text
        $(this).html $(this).html().replace(/&amp;/, "&").replace(text, "")
        return

    else if $(window).width() > 768
      $(".settings-area .nav-tabs a[data-textref]").each ->
        
        # add text back in
        $(this).html $(this).html() + " " + $(this).attr("data-textref")
        $(this).removeAttr "data-textref"
        return

    return

  init: init
  respond: respond
  
$(document).ready ->
  responsive_app.init()
  $(window).resize ->
    responsive_app.respond()
    return

  return