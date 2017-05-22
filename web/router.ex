defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug App.Cookie, ""
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", App do
    pipe_through :browser

    get "/", HomepageController, :index
    post "/", HomepageController, :show
    get "/filter", HomepageController, :filtered_show
    post "/email", SpreadsheetController, :submit_email
    post "/like/:article_id", LikesController, :like
    post "/dislike/:article_id", LikesController, :dislike
    get "/article/:id", ArticleController, :show
    get "/styleguide", StyleGuideController, :index
    get "/info/:page", InfoController, :index
    get "/coming-soon", ComingSoonController, :index
    get "/feedback", FeedbackController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
