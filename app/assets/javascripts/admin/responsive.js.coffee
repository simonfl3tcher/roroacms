responsive_app = do ->
  init = ->
    respond()
    return

  expand = ->
    if not $(".settings-area").hasClass('manual-shrink')
      $('.tab-wrapper').parent().removeAttr('id')
      $(".settings-area .nav-tabs a[data-textref]").each ->
        # add text back in
        $(this).html $(this).html() + " " + $(this).attr("data-textref")
        $(this).removeAttr "data-textref"
        return

  shrink = ->
    $('.tab-wrapper').parent().attr('id', 'collapsed_tabs')
    $(".settings-area .nav-tabs a:not([data-textref])").each ->
      text = $(this).text().replace(" ", "")
      $(this).attr "data-textref", text
      $(this).html $(this).html().replace(/&amp;/, "&").replace(text, "")
      return

  respond = ->
    if $(window).width() < 768
      shrink()
    else if $(window).width() > 768
      expand()

    return

  init: init
  respond: respond
  shrink: shrink
  expand: expand
  
$(document).ready ->
  responsive_app.init()
  $('.shrink').bind 'click', ->
    if $('#collapsed_tabs').length > 0
      $(".settings-area").removeClass('manual-shrink') 
      responsive_app.expand()
    else
      $('.settings-area').addClass('manual-shrink')
      responsive_app.shrink()
  $(window).resize ->
    responsive_app.respond()
    return

  return