defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2, select: 3]
  alias App.CMSRepo

  def index(conn, _params) do
    render conn, "index.html", body: get_body(), tags: get_tags()
  end

  def get_body do
    query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      join: h in "home_homepage",
      where: h.page_ptr_id == page.id,
      select: h.body

    CMSRepo.one(query)
  end

  def get_tags do
    tag_query = from tag in "taggit_tag",
      full_join: h in "articles_categorytag",
      full_join: l in "resources_categorytag",
      where: h.tag_id == tag.id or l.tag_id == tag.id,
      select: tag.name,
      order_by: tag.id,
      distinct: tag.id

    CMSRepo.all(tag_query)
  end

  def show(conn, %{"tags" => %{"tag" => tag}}) do
    article_query = create_tag_query(tag, "articles")

    link_query = create_tag_query(tag, "resources")

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
      _ -> render conn, "index.html",
        tag: tag, resources: all_resources, body: get_body(), tags: get_tags()
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
