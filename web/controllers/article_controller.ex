defmodule App.ArticleController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.CMSRepo

  def index(conn, _params) do
    article_query = from a in "articles_articlepage",
      select: a.body

    articles = CMSRepo.all(article_query)

    render conn, "index.html", articles: articles
  end

  def show(conn, %{"id" => tag}) do
    article_query = from t in "taggit_tag",
      where: t.name == ^tag,
      join: apt in "articles_articlepagetag",
      where: apt.tag_id == t.id,
      join: a in "articles_articlepage",
      where: a.page_ptr_id == apt.content_object_id,
      select: a.body

    case articles = CMSRepo.all(article_query) do
      [] ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "show.html", tag: tag, articles: articles
    end
  end
end
