#!/bin/bash

function check_exit() {
  if [[ $1 -ne 0 ]] ; then
    echo "EXITING - Please fix merge conflicts"
    exit 1
  fi
}

cd ../cms
heroku run "python manage.py dumpdata --natural-foreign --natural-primary" -a ldmw-cms > ../cms_backup.json
git checkout master
git push staging master
heroku run "python manage.py migrate" -a ldmw-cms
cd ../app
heroku run "pg_dump $(heroku config:get DATABASE_URL --app ldmw-app)" -a ldmw-app > ../app_backup.sql
git checkout $1
git push staging $1:master
