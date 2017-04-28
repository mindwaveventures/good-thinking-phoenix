[![Build Status](https://travis-ci.org/ldmw/app.svg?branch=master)](https://travis-ci.org/ldmw/app)
[![codecov](https://codecov.io/gh/ldmw/app/branch/master/graph/badge.svg)](https://codecov.io/gh/ldmw/app)

# app

Built using the _PETE_ stack [`Phoenix`, `Elixir`](http://www.phoenixframework.org/), [`Tachyons`](http://tachyons.io/), and [`Elm`](http://elm-lang.org/)

This project works in tandem with the lmdw cms, for the admin section of the project see: https://github.com/ldmw/cms

### Project Overview

![ldmw-application-architecture-diagram](https://cloud.githubusercontent.com/assets/194400/25229096/cd075eb6-25c6-11e7-8233-5712d55a20fe.png)

Click on image to see large version.
To edit: https://docs.google.com/drawings/d/1NX710eQ_1fJgxctvF3--KOO4S-m-_lOouWg1V_lPtXY

### Project Design

See: zpl.io/ZDwoAh

<img src="https://cloud.githubusercontent.com/assets/16775804/25523681/8262a5d4-2bff-11e7-8023-cd9ba51e6d99.png" />
<img src="https://cloud.githubusercontent.com/assets/16775804/25523711/a48659d0-2bff-11e7-8391-93f402894bdb.png" />
<img src="https://cloud.githubusercontent.com/assets/16775804/25523736/c2ecb324-2bff-11e7-87ce-647ee45e152b.png" />

### Installation and Setup

To get up and running - make sure you have installed:

+ [`node.js`](https://nodejs.org/en/download/) (v6.9)
+ [`elixir`](http://elixir-lang.org/install.html) (1.4)
+ [`phoenix`](http://www.phoenixframework.org/docs/installation) (1.3)
+ [`elm`](https://guide.elm-lang.org/install.html) (0.18)
+ [`postgres`](https://www.postgresql.org/download/) (9.6)

#### Setup

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
$ psql -u $CMS_PG_USER -d cms -c "grant all privileges on all tables in schema public to postgres"
```

And try starting the server again
