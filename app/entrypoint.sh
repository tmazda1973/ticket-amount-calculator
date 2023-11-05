#!/bin/bash
set -e

BUNDLER_VERSION=2.3.26
gem update --system
gem install bundler -v ${BUNDLER_VERSION}
bundle install --jobs=4

#yarn install --check-files
#bundle exec bin/webpack

#mkdir -p /var/tmp/sockets
#mkdir -p /var/tmp/pids
#rm -f /var/tmp/pids/server.pid

exec "$@"
