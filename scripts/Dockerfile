FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

WORKDIR /opt/qubit/qse
COPY ./scripts/entrypoint.sh .

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy sources
COPY assets ./assets
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY mix.exs mix.lock ./

# Initial setup
RUN mix deps.get
RUN MIX_ENV=prod mix compile

# Compile assets
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN MIX_ENV=prod mix phx.digest

# Build the release and overwrite the existing release directory
RUN MIX_ENV=prod mix release --overwrite

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

CMD ["./entrypoint.sh"]
