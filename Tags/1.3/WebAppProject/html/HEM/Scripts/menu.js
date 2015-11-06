$(document).ready(function($) {
	// Code that uses jQuery's $ can follow here.
	$("#mainNav > li").bind('mouseover', function() {
		$(this).children().first().next().show();
	});
	$("#mainNav > li").bind('mouseout', function() {
		$(this).children().first().next().hide();
	});
});

