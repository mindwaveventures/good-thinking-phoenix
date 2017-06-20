defmodule App.HomepageController do
  use App.Web, :controller
  alias App.Resources, as: R
  alias App.Search
  import App.SubmitController, only: [submit: 2]

  def index(conn, _params) do
    session = get_session conn, :lm_session
    resources = "resource"
      |> R.all_query
      |> R.get_resources("resource", session)
      |> R.sort_priority

    render conn, "index.html", content: get_content(),
                 tags: R.get_tags(), resources: resources
  end

  def show(conn, params = %{
      "category" => %{"add_your_own" => cat_suggestion},
      "audience" => %{"add_your_own" => aud_suggestion},
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
        |> Map.take(["audience", "content", "category"])
        |> create_query_string
        |> prepend.("?")

    redirect(conn, to: homepage_path(conn, :filtered_show) <> query_string)
  end

  def filtered_show(conn, params) when params == %{}, do: index(conn, params)
  def filtered_show(conn, %{"category" => category} = params) do
    filters = params
      |> check_empty
      |> Enum.map(&create_filters/1)
      |> Map.new

    selected_tags = filters
      |> Enum.reduce([], fn {_type, tags}, acc -> acc ++ tags end)
      |> Enum.filter(&(!String.starts_with?(&1, "all-")))

    session = get_session conn, "lm_session"
    all_resources = R.get_all_filtered_resources filters, session
    render conn, "index.html",
      content: get_content(), tags: R.get_tags(),
      resources: all_resources, tag: category,
      selected_tags: selected_tags
  end

  def create_filters({tag_type, tags}),
    do: {tag_type, String.split(tags, ",")}

  def check_empty(params) do
    params
    |> Enum.map(fn
        {name, ""} -> {name, "all-#{name}"}
        {name, tags} -> {name, tags}
      end)
  end

  def get_content do
    [:body, :footer, :alpha, :alphatext, :lookingfor,
     :filter_label_1, :filter_label_2, :filter_label_3,
     :assessment_text, :crisis_text]
    |> R.get_content
    |> Map.merge(%{hero_image_url: R.get_image_url("hero_image", "home")})
  end

  def audience_params do
    ["dads", "mums", "parents", "shift-workers", "students"]
      |> Enum.map(&({&1, "false"}))
      |> Map.new
  end
  def content_params do
    ["CBT", "NHS", "app", "article", "assessment", "community", "discussion",
     "forum", "free-trial", "government", "mindfulness", "peer-to-peer",
     "playlist", "podcast", "smart-alarm", "subscription", "tips"]
      |> Enum.map(&({&1, "false"}))
      |> Map.new
      |> Map.merge(%{"subscription" => "true"})
  end

  @doc"""
    iex>audience_map = %{"audience" => audience_params()}
    iex>content_map = %{"content" => content_params()}
    iex>create_query_string(Map.merge(audience_map, content_map))
    "audience=&content=subscription"
  """
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

  def search(conn, %{"query" => %{"query" => query}}) do
    all_resources =
      "resource"
      |> R.all_query
      |> R.get_resources("resource", get_session(conn, :lm_session))
      |> Enum.filter(&(Search.find_matches &1, Search.split_text query))

    render conn, "index.html", content: get_content(), tags: R.get_tags(),
    resources: all_resources, selected_tags: []
  end
end
