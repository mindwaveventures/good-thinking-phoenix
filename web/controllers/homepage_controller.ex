defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2, select: 3]
  alias App.{CMSRepo, Resources}

  def index(conn, _params) do
    render conn, "index.html",
      body: get_content(:body), cat_tags: get_tags("category"),
      aud_tags: get_tags("audience"), con_tags: get_tags("content"),
      footer: get_content(:footer), alphatext: get_content(:alphatext),
      resources: Resources.get_all_resources("resource")
  end

  def get_content(content) do
    query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      join: h in "home_homepage",
      where: h.page_ptr_id == page.id,
      select: %{alphatext: h.alphatext, body: h.body, footer: h.footer}

    query
    |> CMSRepo.one()
    |> Map.get(content)
  end

  def get_tags(type) do
    tag_query = from tag in "taggit_tag",
      full_join: h in ^"articles_#{type}tag",
      full_join: l in ^"resources_#{type}tag",
      where: h.tag_id == tag.id or l.tag_id == tag.id,
      select: tag.name,
      order_by: tag.id,
      distinct: tag.id

    CMSRepo.all(tag_query)
  end

  def show(conn, params) do
    %{
      "category" => %{"category" => tag},
      "audience" => audience,
      "content" => content
    } = params

    true_tuples = fn e ->
      case e do
        {_t, "true"} -> true
        {_t, "false"} -> false
      end
    end

    second_value = fn {a, "true"} -> a end

    audience_filter = Enum.filter_map(audience, true_tuples, second_value)

    content_filter = Enum.filter_map(content, true_tuples, second_value)

    article_query = Resources.create_tag_query(tag, "article")

    link_query = Resources.create_tag_query(tag, "resource")

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
      |> Enum.map(&Resources.get_all_tags/1)
      |> Resources.filter_tags(audience_filter, content_filter)
      |> Enum.sort(&(&1[:priority] <= &2[:priority]))

    case resources do
      [] ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "index.html",
        tag: tag, resources: all_resources, body: get_content(:body),
        cat_tags: get_tags("category"), aud_tags: get_tags("audience"),
        con_tags: get_tags("content"), footer: get_content(:footer),
        alphatext: get_content(:alphatext)
    end
  end
end
