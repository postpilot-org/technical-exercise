FROM ruby:3.0.6

WORKDIR /app
COPY Gemfile Gemfile.lock /app/

RUN apt-get update && apt-get install -y libpq-dev
RUN gem install bundler
RUN bundle install --no-cache --jobs=4 --retry=3

COPY . .
