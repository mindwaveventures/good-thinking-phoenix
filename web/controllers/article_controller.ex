defmodule App.ArticleController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.CMSRepo

  def show(conn, %{"id" => id}) do
    article_query = from a in "articles_articlepage",
      where: a.page_ptr_id == ^String.to_integer(id),
      join: p in "wagtailcore_page",
      where: a.page_ptr_id == p.id,
      select: %{heading: a.heading, body: a.body, title: p.title}

    case article = CMSRepo.one(article_query) do
      nil ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "show.html", article: article, title: article[:title]
    end
  end
end
