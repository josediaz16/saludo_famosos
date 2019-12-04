FROM ruby:2.5.7-slim

RUN apt-get update && \
    apt-get install -y build-essential libxml2 libpq-dev git curl && \
    rm -rf /var/lib/apt/lists/*

RUN gem update bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY .aws /root/.aws

ENTRYPOINT ["./scripts/docker_entrypoint"]
