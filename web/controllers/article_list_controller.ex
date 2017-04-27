defmodule App.ArticleListController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2, select: 3]
  alias App.CMSRepo

  def index(conn, _params) do
    article_query = from a in "articles_articlepage",
      select: %{id: a.page_ptr_id, heading: a.heading}

    link_query = from l in "resource_links_resourcelinkpage",
      select: %{id: l.page_ptr_id, heading: l.heading, url: l.resource_url}

    resources =
      CMSRepo.all(article_query) ++ CMSRepo.all(link_query)
      |> Enum.sort(&(&1[:id] <= &2[:id]))

    render conn, "index.html", resources: resources
  end

  def show(conn, %{"tag" => tag}) do
    article_query = create_tag_query(tag, "articles_articlepage")
    link_query = create_tag_query(tag, "resource_links_resourcelinkpage")

    resources =
      CMSRepo.all(article_query) ++ CMSRepo.all(link_query)
      |> Enum.sort(&(&1[:id] <= &2[:id]))

    case resources do
      [] ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "show.html", tag: tag, resources: resources
    end
  end

  def create_tag_query(tag, type) do
    query = from t in "taggit_tag",
      where: t.name == ^tag,
      join: apt in ^"#{type}tag",
      where: apt.tag_id == t.id,
      join: a in ^type,
      where: a.page_ptr_id == apt.content_object_id

    if type == "resource_links_resourcelinkpage" do
      query
        |> select([t, apt, a], %{
          id: a.page_ptr_id,
          heading: a.heading,
          url: a.resource_url
        })
    else
      query
        |> select([t, apt, a], %{
          id: a.page_ptr_id,
          heading: a.heading
        })
    end
  end
end
