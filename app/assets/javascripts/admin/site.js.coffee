app = do ->
  init = ->
    tooltips()
    toggleMenuLeft()
    toggleMenuRight()
    menu()
    togglePanel()
    closePanel()
    do_checkboxes()
    return

  tooltips = ->
    $("#toggle-left").tooltip()
    return

  togglePanel = ->
    $(".actions > .fa-chevron-down").click ->
      $(this).parent().parent().next().slideToggle "fast"
      $(this).toggleClass "fa-chevron-down fa-chevron-up"
      return

    return

  toggleMenuLeft = ->
    $("#toggle-left").bind "click", (e) ->
      unless $(".sidebar-right").hasClass(".sidebar-toggle-right")
        $(".sidebar-right").removeClass "sidebar-toggle-right"
        $(".main-content-wrapper").removeClass "main-content-toggle-right"
        if getCookie("menu_contracted") is ""
          createCookie "menu_contracted", "true", 30
        else
          deleteCookie "menu_contracted"
      $(".sidebar").toggleClass "sidebar-toggle"
      $(".main-content-wrapper").toggleClass "main-content-toggle-left"
      e.stopPropagation()
      return

    return

  toggleMenuRight = ->
    $("#toggle-right").bind "click", (e) ->
      unless $(".sidebar").hasClass(".sidebar-toggle")
        $(".sidebar").addClass "sidebar-toggle"
        $(".main-content-wrapper").addClass "main-content-toggle-left"
      $(".sidebar-right").toggleClass "sidebar-toggle-right animated bounceInRight"
      $(".main-content-wrapper").toggleClass "main-content-toggle-right"
      if $(window).width() < 660
        $(".sidebar").removeClass "sidebar-toggle"
        $(".main-content-wrapper").removeClass "main-content-toggle-left main-content-toggle-right"
      e.stopPropagation()
      return

    return

  closePanel = ->
    $(".actions > .fa-times").click ->
      $(this).parent().parent().parent().fadeOut()
      return

    return

  menu = ->
    $("#leftside-navigation .sub-menu > a").click (e) ->
      $("#leftside-navigation ul ul").slideUp().prev().find("i.arrow").removeClass("fa-angle-down").addClass "fa-angle-right"
      unless $(this).next().is(":visible")
        $(this).next().slideDown()
        $(this).find("i.arrow").removeClass("fa-angle-right").addClass "fa-angle-down"
      e.stopPropagation()
      return

    return

  
  #End functions
  
  #Dashboard functions
  timer = ->
    $(".timer").countTo()
    return

  
  #Vector Maps 
  map = ->
    $("#map").vectorMap
      map: "world_mill_en"
      backgroundColor: "transparent"
      regionStyle:
        initial:
          fill: "#1ABC9C"

        hover:
          "fill-opacity": 0.8

      markerStyle:
        initial:
          r: 10

        hover:
          r: 12
          stroke: "rgba(255,255,255,0.8)"
          "stroke-width": 3

      markers: [
        {
          latLng: [
            27.9881
            86.9253
          ]
          name: "36 Employees"
          style:
            fill: "#E84C3D"
            stroke: "rgba(255,255,255,0.7)"
            "stroke-width": 3
        }
        {
          latLng: [
            48.8582
            2.2945
          ]
          name: "58 Employees"
          style:
            fill: "#E84C3D"
            stroke: "rgba(255,255,255,0.7)"
            "stroke-width": 3
        }
        {
          latLng: [
            -40.6892
            -74.0444
          ]
          name: "109 Employees"
          style:
            fill: "#E84C3D"
            stroke: "rgba(255,255,255,0.7)"
            "stroke-width": 3
        }
        {
          latLng: [
            34.05
            -118.25
          ]
          name: "85 Employees "
          style:
            fill: "#E84C3D"
            stroke: "rgba(255,255,255,0.7)"
            "stroke-width": 3
        }
      ]

    return

  weather = ->
    icons = new Skycons(color: "white")
    icons.set "clear-day", Skycons.CLEAR_DAY
    icons.set "clear-night", Skycons.CLEAR_NIGHT
    icons.set "partly-cloudy-day", Skycons.PARTLY_CLOUDY_DAY
    icons.set "partly-cloudy-night", Skycons.PARTLY_CLOUDY_NIGHT
    icons.set "cloudy", Skycons.CLOUDY
    icons.set "rain", Skycons.RAIN
    icons.set "sleet", Skycons.SLEET
    icons.set "snow", Skycons.SNOW
    icons.set "wind", Skycons.WIND
    icons.set "fog", Skycons.FOG
    icons.play()
    return

  
  #morris pie chart
  morrisPie = ->
    Morris.Donut
      element: "donut-example"
      data: [
        {
          label: "Chrome"
          value: 73
        }
        {
          label: "Firefox"
          value: 71
        }
        {
          label: "Safari"
          value: 69
        }
        {
          label: "Internet Explorer"
          value: 40
        }
        {
          label: "Opera"
          value: 20
        }
        {
          label: "Android Browser"
          value: 10
        }
      ]
      colors: [
        "#1abc9c"
        "#293949"
        "#e84c3d"
        "#3598db"
        "#2dcc70"
        "#f1c40f"
      ]

    return

  
  #Sliders
  sliders = ->
    $(".slider-span").slider()
    return

  createCookie = (name, value, days) ->
    expires = undefined
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
    document.cookie = name + "=" + value + expires + "; path=/"
    return

  getCookie = (c_name) ->
    if document.cookie.length > 0
      c_start = document.cookie.indexOf(c_name + "=")
      unless c_start is -1
        c_start = c_start + c_name.length + 1
        c_end = document.cookie.indexOf(";", c_start)
        c_end = document.cookie.length  if c_end is -1
        return unescape(document.cookie.substring(c_start, c_end))
    ""

  deleteCookie = (name) ->
    createCookie name, "", -1
    return

  do_checkboxes = ->
    $("input").iCheck
      checkboxClass: "icheckbox_flat-grey"
      radioClass: "iradio_flat-grey"

    return

  
  #return functions
  init: init
  timer: timer
  map: map
  sliders: sliders
  weather: weather
  morrisPie: morrisPie
  createCookie: createCookie
  getCookie: getCookie
  deleteCookie: deleteCookie
  do_checkboxes: do_checkboxes

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
    if app.getCookie("internal_menu_contracted") is "true"
      shrink()
      if $(window).width() < 860 && $(window).width() > 767
        $('.entry-markdown').addClass('active')
    else if $(window).width() < 860 && $(window).width() > 767
      $('.entry-markdown').addClass('active')
      expand()
    else if $(window).width() < 768
      shrink()
    else if $(window).width() > 768
      expand()

    return

  init: init
  respond: respond
  shrink: shrink
  expand: expand
  

#Load global functions
$(document).ready ->
  

  app.init()
  $("#leftside-navigation .sub-menu.active > a").find("i.arrow").removeClass("fa-angle-right").addClass "fa-angle-down"
  
  $('#paginationWrapper').on 'click', (e) ->
    $('#check_all').trigger('ifUnchecked').iCheck('uncheck');
    setTimeout (->
      app.do_checkboxes()
    ), 5

  responsive_app.init()
  
  $('.shrink').bind 'click', ->
    if $('#collapsed_tabs').length > 0
      $(".settings-area").removeClass('manual-shrink') 
      app.deleteCookie("internal_menu_contracted")
      responsive_app.expand()
    else
      $('.settings-area').addClass('manual-shrink')
      app.createCookie("internal_menu_contracted", "true", 30)
      responsive_app.shrink()
  $(window).resize ->
    responsive_app.respond()
    return

  return
