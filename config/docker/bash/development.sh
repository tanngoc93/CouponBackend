#!/bin/bash
set -e

echo
echo "=> Platform: $PLATFORM"

# Remove a potentially pre-existing server.pid for Rails.
rm -f ${APP_DIR}/tmp/pids/server.pid

#
bundle check || bundle install

if [ "$PLATFORM" = "SIDEKIQ" ]; then
  bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
else
  echo
  echo "Create database"
  bundle exec rake db:create
  echo
  echo "Database migration"
  bundle exec rake db:migrate
  echo
  echo "Seed data migration"
  bundle exec rake seed:migrate
  echo
  bundle exec rails s -b 0.0.0.0 -p $PORT
fi



