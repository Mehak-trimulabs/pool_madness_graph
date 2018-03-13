#!/bin/sh

heroku pg:backups:download -r production
rake db:drop
rake db:create
pg_restore --verbose --clean --no-acl --no-owner -d pool_madness_development latest.dump
rm latest.dump