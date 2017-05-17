#!/bin/bash

function check_exit() {
  if [[ $1 -ne 0 ]] ; then
    echo "EXITING - Please fix merge conflicts"
    exit 1
  fi
}

cd ../cms
heroku run "python manage.py dumpdata --natural-foreign --natural-primary" -a ldmw-cms > ../data/cms_backup.json
git checkout master
git push staging master
heroku run "python manage.py migrate" -a ldmw-cms
cd ../app
heroku run "pg_dump $(heroku config:get DATABASE_URL --app ldmw-app)" -a ldmw-app > ../data/app_backup.sql
git checkout $1
git push staging $1:master
cd ../data
git pull origin master
check_exit $?
git add *_backup.*
git commit -m "$(date)" -n
git push origin master
heroku run "mix ecto.migrate" -a ldmw-app
