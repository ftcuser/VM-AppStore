FROM ruby:alpine

RUN apk --update add --virtual build-dependencies build-base ruby-dev openssl-dev libxml2-dev libxslt-dev \
     sqlite-dev libc-dev linux-headers nodejs tzdata

ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app

RUN  gem install bundler \
  && gem install nokogiri -- --use-system-libraries --with-xml2-config=/usr/local/bin/xml2-config --with-xslt-config=/usr/local/bin/xslt-config
  # && cd /app \
  # && bundle config build.nokogiri --use-system-libraries \
  # && bundle install

 #--without development test
ENV BUNDLE_PATH=/app/.bundle/stuff
RUN bundle config build.nokogiri --use-system-libraries \
 && bundle install

ADD . /app
RUN chown -R nobody:nogroup /app
RUN chown -R nobody:nogroup /usr/local/bundle/
# USER nobody

# ENV RAILS_ENV production


CMD bundle exec rails s -b 0.0.0.0
