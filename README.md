source for armcknight.com

# Dependencies

### Jekyll

The blog is built from markdown documents for individual posts into HTML using Jekyll. Then, posts are composed into `index.html`. 

The entire site is run through Jekyll for simplicity, and the generated `_site` directory is pushed to the appropriate branch for GitHub pages to render.

### SASS

Uses SASS for style sheets. 
	
# Building

To build the entire site, including SASS stylesheets, run

	rake build
	
To preview the site on a local machine (after building), 

	rake serve
	
don't forget to 

	rake endserve
	
when you're done!
	
# Publishing

Sync the `_site/` directory to the armcknight.com bucket on AWS. Excludes .git/

	rake publish 

	
