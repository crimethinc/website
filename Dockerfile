FROM ruby:3.1.1

LABEL maintainer="tech@crimethinc.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    nodejs

COPY .ruby-version /usr/src/app/
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
