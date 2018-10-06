init:
	brew bundle
	rbenv exec gem install bundler
	rbenv exec bundle package

build:
	mkdir logs ||:
	pushd server; vapor build --verbose 2>&1 | tee ../logs/vapor_build.log; popd
	rbenv exec bundle exec sass --update css 2>&1 | tee logs/sass_build.log
	rbenv exec bundle exec jekyll build --incremental 2>&1 | tee logs/jekyll_build.log

mux: 
	rbenv exec bundle exec tmuxinator start

stop:
	tmux kill-session -t test ||:
	pg_ctl stop -D /usr/local/var/postgres/ ||:
