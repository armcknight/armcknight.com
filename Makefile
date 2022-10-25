init:
	which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew bundle
	rbenv exec gem install bundler
	rbenv exec bundle package

logs-dir:
	mkdir logs ||:

compile-css:
	rbenv exec bundle exec sass --update web/css 2>&1 | tee logs/sass_compile.log

build-web: logs-dir compile-css
	rbenv exec bundle exec jekyll build --incremental --destination web/_site/dev 2>&1 | tee logs/jekyll_build.log

package-web: logs-dir compile-css
	env JEKYLL_ENV=production rbenv exec bundle exec jekyll build --destination web/_site/prod 2>&1 | tee logs/jekyll_package.log

deploy-web: logs-dir
	aws s3 sync _site/ s3://armcknight.com/ --exclude .git/ --profile armcknight --acl public-read | tee logs/web_deploy.log

serve-local:
	pushd _site && python -m SimpleHTTPServer 4000 --bind localhost &
	open http://localhost:4000

endserve-local:
	killall Python
