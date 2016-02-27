FROM buildpack-deps:wily
MAINTAINER Alessandro Molari <molari.alessandro@gmail.com>

ENV SRC /src

RUN apt-get update -qq && apt-get install -y build-essential

RUN apt-get install -y ruby2.2 ruby2.2-dev
RUN gem install bundler

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

COPY . ${SRC}

WORKDIR ${SRC}

RUN rm Gemfile.lock
RUN bundle install
RUN npm install