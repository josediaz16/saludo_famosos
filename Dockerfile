FROM ruby:2.5.7-slim

RUN apt-get update && \
    apt-get install -y build-essential libxml2 libpq-dev git curl rsync unzip zip && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.0.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY .aws /root/.aws

ENTRYPOINT ["./scripts/docker_entrypoint"]
