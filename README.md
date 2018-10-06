source for armcknight.com

# Development

```sh
# get necessary tools and set up environment
make init

# build the frontend and backend
make build

# if it's your first time testing locally,
make provision-local

# start a tmux session with all required services running locally
make mux
```

Detach from the `tmux` session with `Ctrl-b d` and you can kill all the processes and tmux session with `make stop`.

## Frontend

A website with AJAX calls to supply dynamic content. Hosts and endpoints are defined in `js/endpoints.js`; which host is used depends on whether Jekyll builds for dev (`make build`) or prod (`make publish`).


Sass compiles everything in `web/css` and then Jekyll compiles everything in `web`. For development (`make build`), output is written to `web/_site/dev`, for production (`make publish`) it is written to `web/_site/prod`.

## Backend

A Vapor Swift server that interacts with a PostgreSQL instance.

# Deploying

## Frontend

```sh
# Build the site with `JEKYLL_ENV=production`
make package-web

# sync `web/_site/prod` directory to the armcknight.com bucket on AWS.
make deploy-web
```

## Backend

```sh
make package-server

# if there is no cloud box yet,
make provision-server

make deploy-server
```
