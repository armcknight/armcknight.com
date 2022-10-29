init:
	which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew bundle ||:
	rbenv install --skip-existing
	rbenv exec gem update bundler
	rbenv exec bundle update

_logs-dir:
	mkdir -p logs

_compile-css: _logs-dir
	sass --update css 2>&1 | tee logs/sass_build.log

build: _logs-dir _compile-css
	rbenv exec bundle exec jekyll build --incremental --destination web/_site/dev 2>&1 | tee logs/jekyll_build.log

deploy: _logs-dir
	aws s3 sync _site/ s3://armcknight.com/ --exclude .git/ --profile armcknight --acl public-read | tee logs/web_deploy.log

serve: build
	pushd _site && python -m SimpleHTTPServer 4000 --bind localhost &
	open http://localhost:4000

endserve::
	killall Python
