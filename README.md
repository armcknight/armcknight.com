source for armcknight.com

# Dependencies

### Jekyll

The blog is built from markdown documents for individual posts into HTML using Jekyll. Then, posts are composed into `index.html`.

The entire site is run through Jekyll for simplicity, and the generated `_site` directory (`.gitignore`d) is pushed to the appropriate branch for GitHub pages to render.

### SASS

Uses SASS for style sheets.

# Building

To build the entire site, including SASS stylesheets, run

	make build

To preview the site on a local machine (after building),

	make serve

don't forget to

	make endserve

when you're done!

# Publishing

Sync the `_site/` directory to the armcknight.com bucket on AWS. Excludes .git/

	make publish

and might want to bust the cloudfront cache:

    make bust-cache PATHS=/path

# TODO

- [ ] for each entry in links, list other tags each link has besides the main heading it's appearing under
- [ ] if a tag index only has one entry, hide the "Previously:" header
