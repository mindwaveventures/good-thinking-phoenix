[![Build Status](https://travis-ci.org/LDMW/app.svg?branch=master)](https://travis-ci.org/LDMW/app)
[![codecov](https://codecov.io/gh/ldmw/app/branch/master/graph/badge.svg)](https://codecov.io/gh/ldmw/app)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/LDMW/app.svg)](https://beta.hexfaktor.org/github/LDMW/app)

# app

### Project Design

See: [zpl.io/ZDwoAh](zpl.io/ZDwoAh)

If access is required, please ask the project maintainers!

See the designs in the following links:

+ [Initial Wireframes](https://github.com/LDMW/app/blob/master/INITIAL_WIREFRAMES.md)
+ [Desktop Wireframes](https://github.com/LDMW/app/blob/master/DESKTOP_WIREFRAMES.md)
+ [Tablet Wireframes](https://github.com/LDMW/app/blob/master/TABLET_WIREFRAMES.md)
+ [Mobile Wireframes](https://github.com/LDMW/app/blob/master/MOBILE_WIREFRAMES.md)

### Installation and Setup

To get up and running - make sure you have installed:

+ [`pip`](https://pypi.python.org/pypi/pip) (9.0)
+ [`python`](https://www.python.org/) (3.6)
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

```bash
pip install -r requirements.txt
```

Configure the database
```bash
python manage.py migrate
```

Start the server
```bash
python manage.py runserver
```

The project should now be running at `https://localhost:8000`

### Local testing

To run the tests run:

```bash
python manage.py test
```

### Deployment

The app is set to automatically push from the master branch to the staging area (https://ldmw-app-staging.herokuapp.com/). When we're happy this is working, we will push manually to the production site.

To deploy to the production site, make sure both the app and cms repos are in the same directory on your machine, then, from this directory (app), run `./deploy.sh {branch-you-want-to-deploy}`, for example, if you wanted to deploy a branch called `latest`, you would run `./deploy.sh latest`. If you don't include a branch in the command, it will deploy your master branch.

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

We would suggest that files be no bigger than 1MB.

If the image size is too large, users on poor connections or on mobile data will experience slow performance and increased data download costs.

##### Resolution

Be aware that if an image has too high a resolution, clients will have to download more onto their device causing pages to take longer to load.

If an image has a too low resolution, then the image could be pixilated on high resolution displays.

If possible, please test your proposed image on the [site's staging area](https://ldmw-cms-staging.herokuapp.com/admin) so that you can determine how this will look

##### Preferred file type

Wagtail facilitates GIF, JPEG, PNG, but doesn't specify a preferred file type (you should go for png if you have the choice though)

##### Hero background image

The image should contrasts well with white text on top of it.

The image should be a wide, with a dimention ratio of approximately 3x2, try to aim for a pixel ratio between 500px and 1200px.

Also note that on mobile the hero image will be cropped as we are using a one size fits all image.

Again, please test your image on the [staging area](https://ldmw-cms-staging.herokuapp.com/admin)

