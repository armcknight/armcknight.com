init:
	which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew bundle
	rbenv exec gem install bundler
	rbenv exec bundle package

provision-local:
	postgres -D /usr/local/var/postgres/ &
	sleep 1
	createdb vapor_pg_test ||:
	pg_ctl stop -D /usr/local/var/postgres/

logs-dir:
	mkdir logs ||:

build-server: logs-dir
	pushd server; vapor build --verbose 2>&1 | tee ../logs/vapor_build.log; popd

compile-css:
	rbenv exec bundle exec sass --update web/css 2>&1 | tee logs/sass_compile.log

build-web: logs-dir compile-css
	rbenv exec bundle exec jekyll build --incremental --destination web/_site/dev 2>&1 | tee logs/jekyll_build.log

build: logs-dir build-server build-web

mux:
	rbenv exec bundle exec tmuxinator start

stop:
	tmux kill-session -t test ||:
	pg_ctl stop -D /usr/local/var/postgres/ ||:

package-web: logs-dir compile-css
	env JEKYLL_ENV=production rbenv exec bundle exec jekyll build --destination web/_site/prod 2>&1 | tee logs/jekyll_package.log

deploy-web: logs-dir
	aws s3 sync web/_site/prod s3://armcknight.com/ --profile armcknight --acl public-read | tee logs/web_deploy.log

provision-server:
	heroku create --buildpack https://github.com/armcknight/heroku-buildpack.git # vapor/vapor is supposed to be the stable release but currently doesn't work; mine is forked from its source at https://github.com/vapor-community/heroku-buildpack.git
	heroku stack:set heroku-16 -a <app-name> # the buildpack doesn't work on the current default stack heroku-18, so we must downgrade
	heroku addons:create heroku-postgresql:hobby-dev # provision a database addon

deploy-server:
	git subtree push --prefix server heroku master # push server source to heroku to build and run remotely
