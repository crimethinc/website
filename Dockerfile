FROM ruby:3.1.1

LABEL maintainer="tech@crimethinc.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    nodejs

COPY .ruby-version /usr/src/app/
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

# create a local gem cache
ENV BUNDLE_PATH /gem

RUN bundle install

COPY . /usr/src/app/

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
