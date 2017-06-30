### LDMW Alpha Deployment Plan

This is the deployment plan for ldmw alpha phase. During alpha, the site is being used for controlled user testing and is not available publicly via Google. Note, this process will be refined further into a production deployment plan for the beta phase.

**The alpha deployment plan:**
- Run a backup [script](https://github.com/LDMW/app/blob/master/deploy.sh) (back up all of the data from our cms database and our app database)
- Update the cms heroku branch to match the github master branch and the app heroku branch.
- Run the migration and start the server (see [Procfile](https://github.com/LDMW/app/blob/master/Procfile) and [cms Procfile](https://github.com/LDMW/cms/blob/master/Procfile))
