$(function(){

	$("#intro").typed({
		strings: ["Welcome! My name is Andrew."],
		typeSpeed: 20,
       callback: function(){
		   var cursor = jQuery("#typed-cursor");
		   cursor.remove();
		   $("#job-cursor").show();
		 	$(function(){

		 		$("#job").typed({
		 			strings: ["I work at Twitter, on the Crashlytics SDK for iOS, OSX and tvOS."],
		 			typeSpeed: 20,
			       callback: function(){
			         shift();
			       }
		 		});

		 	});
       }
	});

});

function shift(){
    $(".head-wrap").addClass("shift-text");
}