// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require select2-full
//= require turbolinks
//= require_tree .

function showLoader() {
	$('body').css('overflow', 'hidden')
    $('#overlayLoader').removeClass("hidden").children("#overlayLoader_img").css({ "top": (($(window).height()-30) / 4)+'px', "left": (($(window).width()-20) /4)});
}

function hideLoader() {
	 $('body').css('overflow', 'visible')
      $('#overlayLoader').addClass("hidden");
}