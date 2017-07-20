defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug App.Banner, ""
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
    post "/submit", SubmitController, :submit
    post "/like/:article_id", LikesController, :like
    post "/dislike/:article_id", LikesController, :dislike
    get "/article/:id", ArticleController, :show
    get "/styleguide", StyleGuideController, :index
    get "/coming-soon", ComingSoonController, :index
    get "/feedback", FeedbackController, :index
    post "/feedback", FeedbackController, :post
    get "/crisis", CrisisController, :index
    post "/search", HomepageController, :search
    get "/sleep", LandingPageController, :index
    get "/sleep/tips", LandingPageController, :index
    get "/events/grenfell", LandingPageController, :index
    get "/sleep/talk-about-it", LandingPageController, :index
    get "/:page", StaticController, :index
    # Default route - will match any page - must stay at bottom
  end

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
