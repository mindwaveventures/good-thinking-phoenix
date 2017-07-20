defmodule App.LandingPageController do
  use App.Web, :controller

  def index(conn, _params) do

    path =  case length conn.path_info do
      1 -> List.first conn.path_info
      _ -> Enum.join(conn.path_info, "-")
    end
    # Requires template to have same name as route
    conn
    |> put_layout(false)
    |> render("#{path}.html")
  end
end
