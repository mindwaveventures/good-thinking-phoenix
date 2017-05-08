defmodule App.InfoController do
  use App.Web, :controller

  import Ecto.Query, only: [from: 2, select: 3]

  alias App.CMSRepo

  def index(conn, %{"page" => page}) do
    query = from i in "info_infopage",
      join: w in "wagtailcore_page",
      where: i.page_ptr_id == w.id and w.slug == ^page,
      select: %{
        heading: i.heading,
        body: i.body
      }

    data = CMSRepo.one(query)

    case data do
      nil ->
        conn
        |> put_status(404)
        |> render(App.ErrorView, "404.html")
      _ -> render conn, "index.html", heading: data.heading, body: data.body
    end
  end
end
