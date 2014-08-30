$(document).ready(function(){

  if ($(window).width() >= 768 && $('.js-settings').attr('data-tour-taken') == 'N') {

    // Define the tour!
    var tour = {
      id: "hello-hopscotch",
      onEnd: function(){
        $.ajax({
            type: "post",
            url: $('.js-settings').attr('data-site-url') + 'setup/tour_complete',
            dataType: "html"
          }); 
      },
      steps: [
        {
          title: "Content",
          content: "Everything that you need to manage Articles, Pages, Tags and Categories in one place",
          target: "dashboardContent",
          placement: "right"
        },
        {
          title: "Menus",
          content: "Create and manage your applications menus from here",
          target: "dashboardMenus",
          placement: "right"
        },
        {
          title: "Comments",
          content: "If you have system comments switched on, any comments against articles will be stored here for you to manage",
          target: "dashboardComments",
          placement: "right"
        },
        {
          title: "Settings",
          content: "The application has a number of settings which you are able to manage from here <br /><br /> And that's it, away you go!",
          target: "dashboardSettings",
          placement: "right"
        }
      ]
    };
    // Start the tour!
    hopscotch.startTour(tour);

  }

});

