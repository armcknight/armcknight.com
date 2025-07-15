init:
	which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle ||:
	rbenv install --skip-existing
	rbenv exec gem update bundler
	rbenv exec bundle update

_logs-dir:
	mkdir -p logs

update-resume:
	pushd resume && make build
	cp resume/build/cv.pdf assets/pdf/andrew-mcknight-cv.pdf
	cp resume/build/ios_resume.pdf assets/pdf/andrew-mcknight-resume-ios.pdf

build: _logs-dir
	rbenv exec bundle exec jekyll build --destination _site 2>&1 | tee logs/jekyll_build.log

deploy: _logs-dir
	aws s3 sync _site/ s3://armcknight.com/ --profile armcknight --acl public-read --delete | tee logs/web_deploy.log

serve: build
	pushd _site && python3 -m http.server 4000 --bind localhost &
	open http://localhost:4000

endserve:
	killall Python

# separate multiple paths with a comma and place in a double quoted string, e.g.:
#   make bust-cache PATHS="/experience,/experience/,/experience/index.html"
bust-cache:
	aws --profile armcknight cloudfront create-invalidation --distribution-id E6BG42FYZHWB0 --paths "$(PATHS)"

bust-blog-cache:
	aws --profile armcknight cloudfront create-invalidation --distribution-id E6BG42FYZHWB0 --paths "/blog/" "/blog/index.html"

check-cache-invalidation-status:
	aws --profile armcknight cloudfront list-invalidations --distribution-id E6BG42FYZHWB0
