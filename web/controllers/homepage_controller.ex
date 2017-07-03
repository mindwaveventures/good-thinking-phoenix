defmodule App.HomepageController do
  use App.Web, :controller
  alias App.Resources, as: R
  alias App.Search
  import App.SubmitController, only: [submit: 2]

  def index(conn, _params) do
    session = get_session conn, :lm_session
    resources =
      "resource"
      |> R.all_query
      |> R.get_resources("resource", session)
      |> R.sort_priority

    content = get_content()
    tags = get_tags()
    topics = get_all_topics()

    render conn, "index.html", content: content,
                 tags: tags, resources: resources,
                 topics: topics
  end

  def get_tags do
    [:issue, :reason, :content, :topic]
    |> Map.new(&({&1, R.get_tags(&1)}))
  end

  def show(conn, params = %{
      "issue" => %{"add_your_own" => cat_suggestion},
      "reason" => %{"add_your_own" => aud_suggestion},
      "content" => %{"add_your_own" => con_suggestion}
    }
  ) when (cat_suggestion <> aud_suggestion <> con_suggestion) != ""  do
    conn
    |> submit(%{"tag_suggestion" => [cat_suggestion, aud_suggestion, con_suggestion]})
    |> redirect(to: homepage_path(conn, :show, params))
  end
  def show(conn, params) do
    prepend = fn(a, b) -> b <> a end
    query_string =
      params
        |> Map.take(["reason", "content", "issue", "topic"])
        |> create_query_string
        |> prepend.("?")

    redirect(conn, to: homepage_path(conn, :filtered_show) <> query_string)
  end

  def filtered_show(conn, params) when params == %{}, do: index(conn, params)
  def filtered_show(conn, params) do
    topic = Map.get(params, "topic", nil)
    filters = params
      |> check_empty
      |> Enum.map(fn {type, tags} -> {type, String.split(tags, ",")} end)
      |> Map.new

    selected_tags = filters
      |> Enum.reduce([], fn {type, tags}, acc ->
        case type do
          "topic" -> acc ++ tags
          _ -> acc
        end
      end)
      |> Enum.filter(&(!String.starts_with?(&1, "all-")))

    session = get_session conn, "lm_session"
    all_resources =
      filters
      |> R.get_all_filtered_resources(session)
      |> filter_search(params["q"])
      |> Enum.map(&Map.put(&1, :tags, Map.delete(&1[:tags], "hidden")))

    content = get_content()
    tags = case topic do
      nil -> get_tags()
      _ -> R.get_tags(topic)
    end
    topics = get_all_topics()

    render conn, "index.html",
      content: content, tags: tags,
      resources: all_resources,
      selected_tags: selected_tags, query: params["q"],
      topics: topics
  end

  def check_empty(params) do
    params
    |> Enum.filter_map(fn
        {"", _} -> nil
        _ -> true
      end, fn
        {name, ""} -> {name, "all-#{name}"}
        {name, tags} -> {name, tags}
      end)
  end

  def get_content do
    content =
      R.get_content [:body, :footer, :alpha, :alphatext, :lookingfor,
        :filter_label_1, :filter_label_2, :filter_label_3,
        :assessment_text, :crisis_text, :video_url]

    image_url = R.get_image_url("hero_image", "home")

    Map.merge(content, %{hero_image_url: image_url})
  end

  def get_all_topics do
    query =
      from n in "taggit_tag",
      left_join: t in "resources_topictag",
      where: t.tag_id == n.id,
      select: n.name,
      distinct: n.name

      CMSRepo.all query
  end

  def create_query_string(params) do
    params
    |> Enum.map(fn {tag_type, tag} ->
      {tag_type,
       tag
       |> Enum.reduce("", fn({t, bool}, a) ->
           if bool == "true" do
             "#{a}#{t},"
           else
             a
           end
         end)
       |> String.trim(",")
       |> remove_all_type_tags(tag_type)}
    end)
    |> Enum.filter(fn {_, tag} -> tag != "" end)
    |> URI.encode_query
  end

  def remove_all_type_tags(str, type) do
    type_tag_string = "all-#{type}"
    if str != type_tag_string do
      str
      |> String.replace(type_tag_string, "")
      |> String.trim(",")
    end
  end

  def search(conn, %{"query" => %{"q" => ""}} = params) do
    query_string =
      params
      |> Map.take(["topic"])
      |> create_query_string
    redirect conn,
      to: homepage_path(conn, :filtered_show) <> "?" <> query_string
  end

  def search(conn, %{"query" => %{"q" => q}} = params) do
    query = URI.decode_query(params["query"]["query_string"])
    query_string =
      case Map.get(query, "q") do
        nil -> "?" <> URI.encode_query(q: q) <> "&" <> params["query"]["query_string"]
        _ -> "?" <> URI.encode_query(Map.update!(query, "q", fn _ -> q end))
      end

    redirect(conn, to: homepage_path(conn, :filtered_show) <> query_string)
  end

  def filter_search(resources, nil), do: resources
  def filter_search(resources, query) do
    Enum.filter(resources, &(Search.find_matches &1, Search.split_text query))
  end
end
