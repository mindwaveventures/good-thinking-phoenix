defmodule App.HomepageController do
  use App.Web, :controller
  alias App.{Repo, Likes, ErrorView}
  alias App.Resources, as: R

  def index(conn, _params) do
    session = get_session conn, :lm_session
    resources = "resource"
      |> R.all_query
      |> R.get_resources("resource", session)
      |> R.sort_priority

    render conn, "index.html", content: get_content(),
                 tags: get_tags(), resources: resources
  end

  @doc"""
    iex>%{body: body, footer: footer} = get_content()
    iex>%{alphatext: alphatext, lookingfor: lookingfor} = get_content()
    iex>strings = [body, footer, alphatext, lookingfor]
    iex>substrings = ["London Minds", "Contact", "ALPHA", ""]
    iex>contains = fn {str, substr} -> String.contains?(str, substr) end
    iex>[strings, substrings] |> Enum.zip |> Enum.map(contains) |> Enum.all?
    true
  """
  def get_content do
    [:body, :footer, :alphatext, :lookingfor]
    |> Map.new(&({&1, R.get_content(&1)}))
  end

  @doc"""
    iex>%{audience: audience, category: category, content: content} = get_tags()
    iex>audience
    ["shift-workers", "dads", "parents", "mums", "students"]
    iex>category |> Enum.take(5)
    ["insomnia", "getting-to-sleep", "waking-up", "wellbeing", "general-sleep"]
    iex>content |> Enum.take(5)
    ["article", "tips", "free-trial", "mindfulness", "subscription"]
  """

  def get_tags do
    [:category, :audience, :content]
    |> Map.new(&({&1, R.get_tags(&1)}))
  end

  def show(conn, %{"category" => %{"category" => tag}} = params) do
    prepend = fn(a, b) -> b <> a end
    query_string =
      params
        |> Map.take(["audience", "content"])
        |> create_query_string
        |> prepend.("?category=#{tag}&")

    redirect(conn, to: homepage_path(conn, :query) <> query_string)
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
       |> String.trim(",")}
    end)
    |> URI.encode_query
  end

  def like(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, 1
    handle_like_redirect conn, "Liked!", get_query_string(conn)
  end

  def dislike(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, -1
    handle_like_redirect conn, "Disliked!", get_query_string(conn)
  end

  def get_query_string(conn) do
    url = case Enum.find conn.req_headers, fn {key, _val} -> key == "referer" end do
      nil -> ""
      {"referer", url} -> url
    end

    [_host | query_string] = String.split(url, "?")

    query_string
  end

  def query(conn, params) do
    %{
      "category" => category,
      "audience" => audience,
      "content" => content
    } = params

    case R.check_tag(category) do
      {:error, _} ->
        conn
          |> put_status(404)
          |> render(ErrorView, "404.html")
      {:ok, _} ->
        filters = [audience, content]
          |> Enum.filter(&(&1 != ""))
          |> Enum.map(&(String.split(&1, ",")))
          |> Enum.concat

        session = get_session conn, "lm_session"
        all_resources = R.get_all_filtered_resources category, filters, session
        render conn, "index.html",
          content: get_content(), tags: get_tags(),
          resources: all_resources, tag: category
    end
  end

  defp redirect_path(conn, query) when query == [] do
    homepage_path(conn, :index)
  end
  defp redirect_path(conn, query) do
    homepage_path(conn, :query) <> "?#{query}"
  end
  defp handle_like_redirect(conn, flash, query) do
    conn
    |> put_flash(:info, flash)
    |> redirect(to: redirect_path(conn, query))
  end

  defp handle_like(conn, article_id, like_value) do
    lm_session = get_session(conn, :lm_session)
    like_params = %{user_hash: lm_session,
                    article_id: String.to_integer(article_id),
                    like_value: like_value}
    changeset = Likes.changeset %Likes{}, like_params
    like = Repo.get_by Likes, article_id: article_id, user_hash: lm_session
    case like do
      nil -> Repo.insert!(changeset)
      _ -> like |> Likes.changeset(like_params) |> Repo.update!
    end
  end
end
