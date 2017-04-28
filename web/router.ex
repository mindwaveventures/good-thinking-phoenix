defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", App do
    pipe_through :browser # Use the default browser stack

    get "/", HomepageController, :index
    resources "/article", ArticleController, only: [:show]
    resources "/articles", ArticlesListController, only: [:index, :show]
    get "/styleguide", StyleGuideController, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
