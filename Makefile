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
	rbenv exec bundle exec jekyll build --incremental --destination _site 2>&1 | tee logs/jekyll_build.log

deploy: _logs-dir
	aws s3 sync _site/ s3://armcknight.com/ --profile armcknight --acl public-read --delete | tee logs/web_deploy.log

serve: build
	pushd _site && python3 -m http.server 4000 --bind localhost &
	open http://localhost:4000

endserve:
	killall Python

bust-cache:
	aws --profile armcknight cloudfront create-invalidation --distribution-id E6BG42FYZHWB0 --paths "$(PATHS)"
