var app = function() {

    var init = function() {

        tooltips();
        toggleMenuLeft();
        toggleMenuRight();
        menu();
        togglePanel();
        closePanel();
        do_checkboxes();

    };

    var tooltips = function() {
        $('#toggle-left').tooltip();
    };

    var togglePanel = function() {
        $('.actions > .fa-chevron-down').click(function() {
            $(this).parent().parent().next().slideToggle('fast');
            $(this).toggleClass('fa-chevron-down fa-chevron-up');
        });

    };

    var toggleMenuLeft = function() {
        $('#toggle-left').bind('click', function(e) {
            if (!$('.sidebarRight').hasClass('.sidebar-toggle-right')) {
                $('.sidebarRight').removeClass('sidebar-toggle-right');
                $('.main-content-wrapper').removeClass('main-content-toggle-right');
                if(getCookie('menu_contracted') == '') {
                    createCookie('menu_contracted', 'true', 30);
                } else {
                    deleteCookie('menu_contracted');
                }
            }
            $('.sidebar').toggleClass('sidebar-toggle');
            $('.main-content-wrapper').toggleClass('main-content-toggle-left');
            e.stopPropagation();
        });
    };

    var toggleMenuRight = function() {
        $('#toggle-right').bind('click', function(e) {

            if (!$('.sidebar').hasClass('.sidebar-toggle')) {
                $('.sidebar').addClass('sidebar-toggle');
                $('.main-content-wrapper').addClass('main-content-toggle-left');
                console.log("in here2")
            }
            
            $('.sidebarRight').toggleClass('sidebar-toggle-right animated bounceInRight');
            $('.main-content-wrapper').toggleClass('main-content-toggle-right');

            if ( $(window).width() < 660 ) {
                $('.sidebar').removeClass('sidebar-toggle');
                $('.main-content-wrapper').removeClass('main-content-toggle-left main-content-toggle-right');
             };

            e.stopPropagation();
        });
    };

    var closePanel = function() {
        $('.actions > .fa-times').click(function() {
            $(this).parent().parent().parent().fadeOut();
        });

    }

    var menu = function() {
        $("#leftside-navigation .sub-menu > a").click(function(e) {
            $("#leftside-navigation ul ul").slideUp().prev().find('i.arrow').removeClass('fa-angle-down').addClass('fa-angle-right');
            if (!$(this).next().is(":visible")) {
                $(this).next().slideDown();
                $(this).find('i.arrow').removeClass('fa-angle-right').addClass('fa-angle-down');
            }
            e.stopPropagation();
        });
    };
    
    //End functions

    //Dashboard functions
    var timer = function() {
        $('.timer').countTo();
    };


    //Vector Maps 
    var map = function() {
        $('#map').vectorMap({
            map: 'world_mill_en',
            backgroundColor: 'transparent',
            regionStyle: {
                initial: {
                    fill: '#1ABC9C',
                },
                hover: {
                    "fill-opacity": 0.8
                }
            },
            markerStyle: {
                initial: {
                    r: 10
                },
                hover: {
                    r: 12,
                    stroke: 'rgba(255,255,255,0.8)',
                    "stroke-width": 3
                }
            },
            markers: [{
                latLng: [27.9881, 86.9253],
                name: '36 Employees',
                style: {
                    fill: '#E84C3D',
                    stroke: 'rgba(255,255,255,0.7)',
                    "stroke-width": 3
                }
            }, {
                latLng: [48.8582, 2.2945],
                name: '58 Employees',
                style: {
                    fill: '#E84C3D',
                    stroke: 'rgba(255,255,255,0.7)',
                    "stroke-width": 3
                }
            }, {
                latLng: [-40.6892, -74.0444],
                name: '109 Employees',
                style: {
                    fill: '#E84C3D',
                    stroke: 'rgba(255,255,255,0.7)',
                    "stroke-width": 3
                }
            }, {
                latLng: [34.05, -118.25],
                name: '85 Employees ',
                style: {
                    fill: '#E84C3D',
                    stroke: 'rgba(255,255,255,0.7)',
                    "stroke-width": 3
                }
            }]
        });

    };

    var weather = function() {
        var icons = new Skycons({
            "color": "white"
        });

        icons.set("clear-day", Skycons.CLEAR_DAY);
        icons.set("clear-night", Skycons.CLEAR_NIGHT);
        icons.set("partly-cloudy-day", Skycons.PARTLY_CLOUDY_DAY);
        icons.set("partly-cloudy-night", Skycons.PARTLY_CLOUDY_NIGHT);
        icons.set("cloudy", Skycons.CLOUDY);
        icons.set("rain", Skycons.RAIN);
        icons.set("sleet", Skycons.SLEET);
        icons.set("snow", Skycons.SNOW);
        icons.set("wind", Skycons.WIND);
        icons.set("fog", Skycons.FOG);

        icons.play();
    }

    //morris pie chart
    var morrisPie = function() {

        Morris.Donut({
            element: 'donut-example',
            data: [{
                    label: "Chrome",
                    value: 73
                }, {
                    label: "Firefox",
                    value: 71
                }, {
                    label: "Safari",
                    value: 69
                }, {
                    label: "Internet Explorer",
                    value: 40
                }, {
                    label: "Opera",
                    value: 20
                }, {
                    label: "Android Browser",
                    value: 10
                }

            ],
            colors: [
                '#1abc9c',
                '#293949',
                '#e84c3d',
                '#3598db',
                '#2dcc70',
                '#f1c40f'
            ]
        });
    }

    //Sliders
    var sliders = function() {
        $('.slider-span').slider()
    };

    var createCookie = function(name, value, days) {
        var expires;
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        }
        else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    }

    var getCookie = function(c_name) {
        if (document.cookie.length > 0) {
            c_start = document.cookie.indexOf(c_name + "=");
            if (c_start != -1) {
                c_start = c_start + c_name.length + 1;
                c_end = document.cookie.indexOf(";", c_start);
                if (c_end == -1) {
                    c_end = document.cookie.length;
                }
                return unescape(document.cookie.substring(c_start, c_end));
            }
        }
        return "";
    }

    var deleteCookie = function(name) {
        createCookie(name,"",-1);
    }

    var do_checkboxes = function(){
        $('input').iCheck({
            checkboxClass: 'icheckbox_flat-grey',
            radioClass: 'iradio_flat-grey'
        });
    }



    //return functions
    return {
        init: init,
        timer: timer,
        map: map,
        sliders: sliders,
        weather: weather,
        morrisPie: morrisPie,
        createCookie: createCookie,
        getCookie: getCookie,
        do_checkboxes: do_checkboxes

    };
}();
//Load global functions
$(document).ready(function() {
    app.init();

    $("#leftside-navigation .sub-menu.active > a").find('i.arrow').removeClass('fa-angle-right').addClass('fa-angle-down');
    
});
