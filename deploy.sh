#!/bin/bash
# Backup App and CMS data, then deploy to heroku. First argument is branch/commit from app to deploy
# Expects cms and app to directories to share a parent directory

starting_branch="$(git branch | grep \* | cut -d ' ' -f2)"

if [ -z "$1" ]; then
  echo "No argument supplied, deploying master branch"
  branch_to_deploy=master
else
  branch_to_deploy=$1
fi

# Backup cms data, then deploy to heroku
function deploy_cms() {
  heroku run "python manage.py dumpdata --natural-foreign --natural-primary" -a ldmw-cms > ../cms_backup.json
  git checkout master
  git push heroku master
  heroku run "python manage.py migrate" -a ldmw-cms
}

# Backup app data, then deploy from commit/branch passed as first argument to heroku
function deploy_app() {
  heroku run "pg_dump $(heroku config:get DATABASE_URL --app ldmw-app)" -a ldmw-app > ../app_backup.sql
  git checkout $branch_to_deploy
  git push heroku $branch_to_deploy:master
}

cd ../cms
deploy_cms
cd ../app
deploy_app
git checkout $starting_branch #reset branch back to original
