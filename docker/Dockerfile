FROM ubuntu:20.04

MAINTAINER Artem Salagaev: gitsartem@gmail.com

# prepare build dir
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y curl gnupg
RUN curl -O https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update && \
    apt-get install -y esl-erlang \
                       elixir \
                       git

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# compile and build release
COPY lib lib
RUN mix do compile, release


COPY _build/prod/rel/radicula ./

ENV HOME=/app

CMD ["bin/radicula", "start"]
