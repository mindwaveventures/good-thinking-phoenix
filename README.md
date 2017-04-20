# app

Built using the _PETE_ stack [`Phoenix`, `Elixir`](http://www.phoenixframework.org/), [`Tachyons`](http://tachyons.io/), and [`Elm`](http://elm-lang.org/)

As well as the [`Wagtail`](https://wagtail.io/) CMS

### Installation and Setup

To get up and running - make sure you have installed:

+ [`node.js`](https://nodejs.org/en/download/) (v6.9)
+ [`elixir`](http://elixir-lang.org/install.html) (1.4)
+ [`phoenix`](http://www.phoenixframework.org/docs/installation) (1.3)
+ [`elm`](https://guide.elm-lang.org/install.html) (0.18)
+ [`postgres`](https://www.postgresql.org/download/) (9.6)
+ [`python`](https://www.python.org/) (3.6)

Clone the repository and cd into it (make sure you don't have another project called `app`):

```bash
git clone https://github.com/ldmw/app.git && cd app
```

Ensure to have the following environment variables in your `$PATH`

```bash
export CMS_PG_USER=<cms_postgres_username>
export CMS_PG_PASS=<cms_postgres_password>
export CMS_HOST=<cms_host>
export CMS_PORT=<cms_port>
```

(Ensure postgres is running with: `postgres -D /usr/local/var/postgres/`)

#### Main app setup

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

#### CMS setup:

(Ensure postgres is running with: `postgres -D /usr/local/var/postgres/`)

(For the most up to date setup see the wagtail [getting started guide](https://wagtail.io/developers/))

From the root, change into the `cms` directory:

```bash
cd cms
```

Set up the database:

```bash
python manage.py migrate
```

If you get the error `FATAL: database "cms" does not exist`

You can create this database with:

```bash
psql -U $CMS_PG_USER -c "create database cms"
```

Then run this command again

Create an admin account:

```bash
python manage.py createsuperuser
python manage.py runserver
```

The project should now be running at: `http://localhost:8000/admin`

