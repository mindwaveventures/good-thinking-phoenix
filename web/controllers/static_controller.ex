defmodule App.StaticController do
  use App.Web, :controller

  def index(conn, %{"page" => page}) do
    query = from i in "static_staticpage",
      join: w in "wagtailcore_page",
      where: i.page_ptr_id == w.id and w.slug == ^page,
      select: %{
        body: i.body
      }

    data = CMSRepo.one query

    case data do
      nil ->
        conn
        |> put_status(404)
        |> render(App.ErrorView, "404.html")
      _ -> render conn, "index.html", body: data.body
    end
  end
end
