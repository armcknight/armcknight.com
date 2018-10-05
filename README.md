source for armcknight.com

# Development

First things first: 

```sh
# get necessary tools and set up environment
make init

# build the frontend and backend
make build

# start a tmux session with all required services running locally
make mux
```

Detach from the `tmux` session with `Ctrl-b d` and you can kill all the processes and tmux session with `make stop`.

# Publishing

Sync the `_site/` directory to the armcknight.com bucket on AWS. Excludes .git/

	rake publish 

# Dependencies

## Frontend

### Development

#### Jekyll

The blog is built from markdown documents for individual posts into HTML using Jekyll. Then, posts are composed into `index.html`. 

The entire site is run through Jekyll for simplicity, and the generated `_site` directory (`.gitignore`d) is pushed to the appropriate branch for GitHub pages to render.

### SASS

Uses SASS for style sheets.

## Backend

### PostgreSQL

Database and its server.

### Development

#### Vapor

A framework and CLI for developing Swift server applications.
