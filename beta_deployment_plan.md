### LDMW Beta Deployment Plan

This is the deployment plan for LDMW beta phase. The site is currently being used for controlled user testing and is not available publicly via Google.

**The Beta Deployment Plan:**
- Run a backup script (should copy all heroku data into a local `dump.json` file)
`heroku run "python manage.py dumpdata --natural-foreign --natural-primary" -a ldmw-cms > ../cms_backup.json`
- locally reset hard to `heroku/master`
- reset your database
- dump that data into your local database
- run the app to ensure everything is working locally
- Checkout to `ldmw/cms` current `master` locally
- [Run the migrations](https://github.com/LDMW/cms/blob/master/Procfile) and ensure the app runs fine
- Double check that heroku has done a backup of the database for that day
- Double check that you have the current `git` remote `master` as your local master
- Push to heroku master
- Follow build logs to make sure everything is working

#### Planning a deployment

As deploying can involve risks, deployments should not be done on Friday's to
protect against needing time to fix any unexpected bugs.

Deployments will occur at the end of every sprint. Additional deployments can
occur during the sprint however, these should be agreed during sprint planning
so that both the design and development teams know which features should be
approved before this takes place and when this deployment should happen.
