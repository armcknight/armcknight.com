init:
	brew bundle
	rbenv exec gem install bundler
	rbenv exec bundle package

build:
	pushd server
	vapor build --verbose > vapor_build.log 2>&1
	popd
	rbenv exec bundle exec sass --update css > sass_build.log 2>&1
	rbenv exec bundle exec jekyll build --incremental > jekyll_build.log 2>&1

mux: 
	rbenv exec bundle exec tmuxinator start

stop:
	tmux kill-session -t test ||:
	pg_ctl stop -D /usr/local/var/postgres/ ||:
