defmodule App.LandingPageController do
  use App.Web, :controller

  def index(conn, _params) do
    path = List.first conn.path_info
    # Requires template to have same name as route
    conn
    |> put_layout(false)
    |> render("#{path}.html")
  end
end
