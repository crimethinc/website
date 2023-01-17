# syntax=docker/dockerfile:1
FROM ruby:3.1.3
WORKDIR /crimethinc
COPY . .
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client ruby-full git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

RUN gem install bundler --conservative && gem install os && bundle install

CMD bundle exec rails db:create && bundle exec rails db:migrate && ./script/server

EXPOSE 3000