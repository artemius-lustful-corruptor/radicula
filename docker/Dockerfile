FROM elixir:1.12.0-alpine AS build

MAINTAINER Artem Salagaev: gitsartem@gmail.com

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY ../mix.exs mix.lock ./
COPY ../config config
RUN mix do deps.get, deps.compile

# compile and build release
COPY ../lib lib
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/radicula ./

ENV HOME=/app

CMD ["bin/radicula", "start"]