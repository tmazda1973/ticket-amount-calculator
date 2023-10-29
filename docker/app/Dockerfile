FROM node:18.18.2-slim-bullseye as node
FROM ruby:3.2.2-slim-bullseye

ENV LANG C.UTF-8
ENV TZ='Asia/Tokyo'

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends && \
    apt-get -y install imagemagick build-essential libpq-dev libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

# Entrykitインストール
ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

# yarnインストール
ENV YARN_VERSION 1.22.5
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN mkdir -p $APP_HOME/tmp/sockets
RUN mkdir -p $APP_HOME/tmp/pids
RUN mkdir -p /var/tmp/sockets
RUN mkdir -p /var/tmp/pids
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY public $APP_HOME/public

# vimインストール
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]

# bundle install
RUN gem update bundler
RUN bundle install
