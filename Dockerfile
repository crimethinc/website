# syntax=docker/dockerfile:1
FROM ruby:3.1.3
WORKDIR /crimethinc
COPY . .
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN gem install bundler --conservative && gem install os && bundle install

ENTRYPOINT ["rails", "server"]

EXPOSE 3000
