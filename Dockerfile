FROM ruby:2

RUN apt-get update \
        && apt-get install -y apt-transport-https software-properties-common \
        && add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" \
        && curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add -

RUN apt-get update && apt-get install -y heroku nodejs && apt-get clean

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install --without production

COPY . /usr/src/app/
RUN echo > /usr/src/app/script/bootstrap \
        && chown -R www-data:www-data /usr/src/app \
        && install -d -m 755 -o www-data -g www-data /var/www \
        && install -d -m 755 -o www-data -g www-data /usr/src/app/tmp \
        && install -d -m 755 -o www-data -g www-data /usr/src/app/log

USER www-data
EXPOSE 3000

CMD ["/usr/src/app/script/server"]
