var responsive_app = function() {

  var init = function() {
      respond();
  };

  var respond = function() {
    if($(window).width() < 768) {
      $('.settings-area .nav-tabs a:not([data-textref])').each(function(){
        var text = $(this).text().replace(' ', '');
        $(this).attr('data-textref', text);
        $(this).html($(this).html().replace(/&amp;/, "&").replace(text, ''));
      });
    } else if($(window).width() > 768) {
      $('.settings-area .nav-tabs a[data-textref]').each(function(){
        // add text back in
        $(this).html($(this).html() + ' ' + $(this).attr('data-textref'))
        $(this).removeAttr('data-textref');
      });
    }
  };
  return {
    init: init,
    respond: respond
  }

}();

$(document).ready(function(){
  responsive_app.init();
  $( window ).resize(function() {
    responsive_app.respond();
  });
})