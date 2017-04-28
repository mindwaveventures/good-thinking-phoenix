defmodule App.ArticleListController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2, select: 3]
  alias App.CMSRepo

  def index(conn, _params) do
    article_query = from a in "articles_articlepage",
      select: %{id: a.page_ptr_id, heading: a.heading}

    link_query = from l in "resources_resourcepage",
      select: %{id: l.page_ptr_id, heading: l.heading, url: l.resource_url}

    resources =
      CMSRepo.all(article_query) ++ CMSRepo.all(link_query)
      |> Enum.sort(&(&1[:id] <= &2[:id]))
      |> IO.inspect

    render conn, "index.html", resources: resources
  end

  def show(conn, %{"tag" => tag}) do
    article_query = create_tag_query(tag, "articles")

    link_query =
      create_tag_query(tag, "resources")

    articles =
      article_query
      |> CMSRepo.all
      |> Enum.map(&(Map.merge(&1, %{type: "articles"})))

    resources =
      link_query
      |> CMSRepo.all
      |> Enum.map(&(Map.merge(&1, %{type: "resources"})))

    all_resources =
      articles ++ resources
      |> Enum.map(&(get_all_tags(&1)))
      |> Enum.sort(&(&1[:id] <= &2[:id]))

    case resources do
      [] ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "show.html",
        tag: tag, resources: resources, title: String.capitalize(tag)
    end
  end

  def create_tag_query(tag, type) do
    query = from t in "taggit_tag",
      where: t.name == ^tag,
      join: cat in ^"#{type}_categorytag",
      where: cat.tag_id == t.id,
      join: a in ^"#{type}_#{String.slice(type, 0..-2)}page",
      where: a.page_ptr_id == cat.content_object_id

    if type == "resources" do
      query
        |> select([t, cat, a], %{
          id: a.page_ptr_id,
          heading: a.heading,
          url: a.resource_url,
          body: a.body
        })
    else
      query
        |> select([t, cat, a], %{
          id: a.page_ptr_id,
          heading: a.heading
        })
    end
  end

  def get_all_tags(resource) do
    query = from t in "taggit_tag",
      left_join: cat in ^"#{resource.type}_categorytag",
      on: t.id == cat.tag_id,
      left_join: cot in ^"#{resource.type}_contenttag",
      on: t.id == cot.tag_id,
      left_join: aut in ^"#{resource.type}_audiencetag",
      on: t.id == aut.tag_id,
      where: ^resource.id == cat.content_object_id
      or ^resource.id == cot.content_object_id
      or ^resource.id == aut.content_object_id,
      select: t.name,
      distinct: t.name

    Map.merge(%{tags: CMSRepo.all(query)}, resource)
  end
end
