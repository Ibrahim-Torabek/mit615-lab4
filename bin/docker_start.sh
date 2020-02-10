#!/bin/bash

#Author: Andrea Itivver
set +e
echo "================= Attempting to Migrate the DB =================="
bin/rails db:migrate 2>/dev/null

RET=$?
set -e
if [ $RET -gt 0 ]; then
  echo "================= Migration Failed; Creating the Database =================="
  bin/rails db:create
  echo "================= Migrating the Database =================="
  bin/rails db:migrate
  bin/rails db:test:prepare
  echo "================= Seeding the Database =================="
  bin/rails db:seed
fi

echo "================= Removing the old server PID =================="
rm -f tmp/pids/server.pid
echo "================= Stating the web server =================="
bin/rails server -p 3000 -b '0.0.0.0'