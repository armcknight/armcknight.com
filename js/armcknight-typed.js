function showIntro() {
	$("#intro").typed({
		strings: ["Welcome! My name is Andrew.^1000"],
		typeSpeed: 20,
		callback: function() {
			jQuery("#typed-cursor").remove();
			jQuery("#job-cursor").show();
			showJob();
		}
	});
}

function showJob() {
	$("#job").typed({
		strings: ["I work at Twitter, on the Fabric team in Boston.^1000"],
		typeSpeed: 20,
		callback: function() {
			jQuery("#typed-cursor").remove();
			jQuery("#work-cursor").show();
			showWork();
		}
	});
}

function showWork() {
	$("#work").typed({
		strings: ["I help maintain the Crashlytics SDK for iOS, OSX and tvOS, and our OSX app.^1000"],
		typeSpeed: 20,
		callback: function() {
			jQuery("#typed-cursor").remove();
			jQuery("#prior-work-cursor").show();
			showPriorWork();
		}
	});
}

function showPriorWork() {
	$("#prior-work").typed({
		strings: ["I previously developed mobile apps full time at Insight Therapeutics, Raizlabs and MC10.^1000"],
		typeSpeed: 20,
		callback: function() {
			jQuery("#typed-cursor").remove();
			jQuery("#side-work-cursor").show();
			showSideWork();
		}
	});
}

function showSideWork() {
	$("#side-work").typed({
		strings: ["I also write fun little apps in my spare time.^300 Check out my portfolio page!^1000"],
		typeSpeed: 20,
		callback: function() {
			jQuery("#typed-cursor").remove();
			jQuery("#interests-cursor").show();
			showInterests();
		}
	});
}

function showInterests() {
	$("#interests").typed({
		strings: ["When I'm not coding, I'm snowboarding, hiking, traveling, cooking, playing music, sketching, rock climbing, biking, or something else exciting!"],
		typeSpeed: 20
	});
}

$(function() {
	showIntro();
});
