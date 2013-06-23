$(document).ready(function(){

		$(window).on('mercury:ready', function() {
	  Mercury.Snippet.load({
	    snippet_1: {name: 'example', options: {'options[favorite_beer]': "Bells Hopslam", 'options[first_name]': "Jeremy"}},
	    snippet_1: {name: 'Snippet example', options: {'options[favorite_beer]': "Bells Hopslam", 'options[first_name]': "Jeremy"}},
	  });
});


});