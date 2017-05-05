defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2, select: 3]
  alias App.CMSRepo

  @http Application.get_env(:app, :http)

  def index(conn, _params) do
    render conn, "index.html",
      body: get_content(:body), cat_tags: get_tags("category"),
      aud_tags: get_tags("audience"), con_tags: get_tags("content"),
      footer: get_content(:footer), alphatext: get_content(:alphatext),
      lookingfor: get_content(:lookingfor)
  end

  def get_content(content) do
    query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      join: h in "home_homepage",
      where: h.page_ptr_id == page.id,
      select: %{alphatext: h.alphatext,
                body: h.body,
                footer: h.footer,
                lookingfor: h.lookingfor}

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
      |> filter_tags(audience_filter, content_filter)
      |> Enum.sort(&(&1[:id] <= &2[:id]))

    case resources do
      [] ->
        conn
          |> put_status(404)
          |> render(App.ErrorView, "404.html")
      _ -> render conn, "index.html",
        tag: tag, resources: all_resources, body: get_content(:body),
        cat_tags: get_tags("category"), aud_tags: get_tags("audience"),
        con_tags: get_tags("content"), footer: get_content(:footer),
        alphatext: get_content(:alphatext), lookingfor: get_content(:lookingfor)
    end
  end

  def filter_tags(resources, audience_filter, content_filter) do
    Enum.filter(resources, fn e ->
      Enum.all?(audience_filter, fn a -> a in e.tags end) and
      Enum.all?(content_filter, fn c -> c in e.tags end)
    end)
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

  def submit_email(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    handle_email(conn, "Suggestions", suggestions)
  end

  def submit_email(conn, %{"email" => %{"email" => email}}) do
    handle_email(conn, "Email", email)
  end

  defp handle_email(conn, type, data) do
    @http.post_spreadsheet(data)

    conn
      |> put_flash(:info, "#{type} collected")
      |> redirect(to: homepage_path(conn, :index))
  end
end
