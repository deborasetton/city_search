FROM ruby:2.7.1-buster

RUN apt-get update -qq && apt-get install -y postgresql-client

RUN gem update --system
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

EXPOSE 3000
