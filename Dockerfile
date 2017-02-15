FROM ruby:alpine

RUN apk --update add --virtual build-dependencies build-base ruby-dev openssl-dev libxml2-dev libxslt-dev \
      postgresql-dev sqlite-dev libc-dev linux-headers nodejs tzdata

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN  gem install bundler \
  && gem install nokogiri -- --use-system-libraries --with-xml2-config=/usr/local/bin/xml2-config --with-xslt-config=/usr/local/bin/xslt-config \
  && cd /app \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install

 #--without development test

ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody

# ENV RAILS_ENV production
# ENV BUNDLE_PATH=/app/.bundle/stuff
WORKDIR /app

CMD ["bundle", "exec", "rails", "s"]
