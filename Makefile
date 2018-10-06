init:
	brew bundle
	rbenv exec gem install bundler
	rbenv exec bundle package

build-logs:
	mkdir logs ||:

build-server: build-logs
	pushd server; vapor build --verbose 2>&1 | tee ../logs/vapor_build.log; popd

build-web: build-logs
	rbenv exec bundle exec sass --update css 2>&1 | tee logs/sass_build.log
	rbenv exec bundle exec jekyll build --incremental --destination _site/dev 2>&1 | tee logs/jekyll_build.log

build: build-logs build-server build-web

mux: 
	rbenv exec bundle exec tmuxinator start

stop:
	tmux kill-session -t test ||:
	pg_ctl stop -D /usr/local/var/postgres/ ||:

publish:
	env JEKYLL_ENV=production rbenv exec bundle exec jekyll build --destination _site/prod 2>&1 | tee logs/jekyll_build.log
	aws s3 sync _site/prod s3://armcknight.com/ --exclude .git/ --profile armcknight --acl public-read
