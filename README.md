[![Build Status](https://travis-ci.org/LDMW/app.svg?branch=master)](https://travis-ci.org/LDMW/app)
[![codecov](https://codecov.io/gh/ldmw/app/branch/master/graph/badge.svg)](https://codecov.io/gh/ldmw/app)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/LDMW/app.svg)](https://beta.hexfaktor.org/github/LDMW/app)

# app

Built using the _PETE_ stack [`Phoenix`, `Elixir`](http://www.phoenixframework.org/), [`Tachyons`](http://tachyons.io/)

This project works in tandem with the lmdw cms, for the admin section of the project see: https://github.com/ldmw/cms

### Project Overview

![ldmw-application-architecture-diagram](https://cloud.githubusercontent.com/assets/194400/25229096/cd075eb6-25c6-11e7-8233-5712d55a20fe.png)

Click on image to see large version.
To edit: https://docs.google.com/drawings/d/1NX710eQ_1fJgxctvF3--KOO4S-m-_lOouWg1V_lPtXY

### Project Design

See: [zpl.io/ZDwoAh](zpl.io/ZDwoAh)

If access is required, please ask the project maintainers!

![styleguide](https://cloud.githubusercontent.com/assets/25007700/26722908/f07d8e26-4789-11e7-871e-845fff58bcab.png)

### Installation and Setup

To get up and running - make sure you have installed:

+ [`node.js`](https://nodejs.org/en/download/) (v6.9)
+ [`elixir`](http://elixir-lang.org/install.html) (1.4)
+ [`phoenix`](http://www.phoenixframework.org/docs/installation) (1.3)
+ [`postgres`](https://www.postgresql.org/download/) (9.6)

#### Setup

Ensure to have the following environement variables in your path:
```bash
export GOOGLE_SHEET_URL=<google_sheet_url_email>
```

See the google drive for these

Clone the repository and cd into it (make sure you don't have another project called `app`):

```bash
git clone https://github.com/ldmw/app.git && cd app
```

(Ensure postgres is running with: `postgres -D /usr/local/var/postgres/`)

Go into the app directory

```bash
cd app
```

Install the dependencies:

```elixir
mix deps.get
```

Set up the database:

```elixir
mix do ecto.create, ecto.migrate
```

Start the server

```elixir
mix phoenix.server
```

(For information on any of these commands run `mix help <command>`)

The project should now be running at `https://localhost:4000`

If you get the error:

```bash
ERROR 42501 (insufficient_privilege): permission denied for relation wagtailcore_page
```

You will need to grant access to the user "postgres"

To do so try running this command:
```bash
$ psql -d cms -c "grant all privileges on all tables in schema public to postgres"
```

And try starting the server again

If you get the error:

```bash
column articles_articlepage.heading does not exist
LINE 1: ...reated_at", "articles_articlepage"."page_ptr_id", "articles_...
```

You can fix this with:

```bash
$ psql -d cms -c "alter table articles_articlepage add column heading varchar not null default ''"
```

### Local testing

Ensure that your have the most up to date `dumpdata.json` file from the dumpdata branch on the cms repo

To do so, ensure you are on the `dumpdata` branch and `git pull origin dumpdata`

Then run:
```bash
python manage.py loaddata dumpdata.json
```

### Deployment

The app is set to automatically push from the master branch to the staging area (https://ldmw-app-staging.herokuapp.com/). When we're happy this is working, we will push manually to the production site.

To deploy to the production site, make sure both the app and cms repos are in the same directory on your machine, then, from this directory (app), run `./deploy.sh {branch-you-want-to-deploy}`, for example, if you wanted to deploy a branch called `latest`, you would run `./deploy.sh latest`. If you don't include a branch in the command, it will deploy your master branch.

### CMS

The documentation for the CMS (Creating pages, tags etc) can be found at https://github.com/LDMW/cms#cms

### Analytics

We are using Google Analytics and Google Tag Manager to track user actions on the site. We are currently tracking:
* Page views
* Clicks on the 'Take assessment' button
* Clicks on the 'share' button on resources, and the url of the resource being shared
* Clicks on the 'like' or 'dislike' button, the url of the resource and the value (like/dislike)
* Clicks to the 'Get urgent support' link
* Submission of email to the alpha
* Submission of Feedback
* Visits to each resource link
* Visits to the feedback page

### Google sheets
We are using google sheets for quick easy storage of feedback collected
We have opted for a single spreadsheet with multiple tabs as multiple spreadsheets would be less manageable for both developer and client
(Granting privileges for each one going between different files, etc)

We have opted for using [Better Logger](https://github.com/peterherrmann/BetterLog) so that we can see logged outputs for debugging

When running the app locally, ensure you are using the development `GOOGLE_SHEET_URL` environment variable not the production one
(See google drive for this)

If updating your environment variable doesn't work, try `rm -rf _build` and then starting your server again

### Image uploads

##### File size

The Wagtail cms allows for a maximum file size of 10MB.

Be aware though that many uploads of high resolution images will result in increased costs from our file hosting provider.

##### Resolution

Be aware that if an image has too high a resolution, clients will have to download more onto their device causing pages to take longer to load.

If an image has a too low resolution, then the image could be pixilated on high resolution displays.

##### Preferred file type

Wagtail facilitates GIF, JPEG, PNG, but doesn't specify a preferred file type (you should go for png if you have the choice though)

##### Hero background image

The image should contrasts well with white text on top of it

The image should be a wide, with a dimention ratio of approximately 3x2, try to aim for a pixel ratio between 500px and 1200px

