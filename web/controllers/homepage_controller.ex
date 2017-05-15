defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.{CMSRepo, Repo, Resources, Likes, ErrorView}

  @http Application.get_env :app, :http
  @google_sheet_url_email Application.get_env :app, :google_sheet_url_email
  @google_sheet_url_suggestion Application.get_env(
    :app, :google_sheet_url_suggestion)

  def index(conn, _params) do
    render conn, "index.html", content: get_content(), tags: get_tags(),
    resources: Resources.get_all_resources("resource")
  end

  def get_content do
    [:body, :footer, :alphatext, :lookingfor]
    |> Map.new(&({&1, get_content(&1)}))
  end

  def get_tags do
    [:category, :audience, :content]
    |> Map.new(&({&1, get_tags(Atom.to_string(&1))}))
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
    |> CMSRepo.one
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

    CMSRepo.all tag_query
  end

  defp true_tuples({_t, "true"}), do: true
  defp true_tuples({_t, "false"}), do: false
  defp second_value({a, "true"}), do: a

  @types ["article", "resource"]
  defp handle_article_or_resource(tag, type) when type in @types do
    tag
    |> Resources.create_tag_query(type)
    |> CMSRepo.all
    |> Enum.map(&(Map.merge(&1, %{type: "#{type}s"})))
  end

  def show(conn, params) do
    %{
      "category" => %{"category" => tag},
      "audience" => audience,
      "content" => content
    } = params

    audience_filter = Enum.filter_map(audience, &true_tuples/1, &second_value/1)
    content_filter = Enum.filter_map(content, &true_tuples/1, &second_value/1)

    articles = handle_article_or_resource(tag, "article")
    resources = handle_article_or_resource(tag, "resource")

    all_resources =
      articles ++ resources
      |> Enum.map(&Resources.get_all_tags/1)
      |> Enum.map(&Resources.get_all_likes/1)
      |> Resources.filter_tags(audience_filter, content_filter)
      |> Enum.sort(&(&1[:priority] <= &2[:priority]))

    case resources do
      [] ->
        conn
          |> put_status(404)
          |> render(ErrorView, "404.html")
      _ -> render conn, "index.html",
        content: get_content(), tags: get_tags(),
        resources: all_resources, tag: tag
    end
  end

  def like(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, 1
    handle_like_redirect conn, "Liked!"
  end

  def dislike(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, -1
    handle_like_redirect conn, "Disliked!"
  end

  defp handle_like_redirect(conn, flash) do
    conn
      |> put_flash(:info, flash)
      |> redirect(to: homepage_path(conn, :index))
  end

  defp handle_like(%{cookies: %{"_app_key" => hash}},
                  article_id,
                  like_value) do
    like_params = %{user_hash: hash,
                    article_id: String.to_integer(article_id),
                    like_value: like_value}
    changeset = Likes.changeset %Likes{}, like_params

    case like = Repo.get_by Likes, article_id: article_id, user_hash: hash do
      nil -> Repo.insert!(changeset)
      _ -> like |> Likes.changeset(like_params) |> Repo.update!
    end
  end

  def submit_email(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    handle_email conn, "suggestions", suggestions, @google_sheet_url_suggestion
  end

  def submit_email(conn, %{"email" => %{"email" => email}}) do
    handle_email conn, "email", email, @google_sheet_url_email
  end

  defp handle_email(conn, type, data, url) do
    @http.post_spreadsheet data, url, type

    message = case type do
      "email" -> "Email address entered successfully!"
      "suggestions" -> "Suggestion submitted successfully!"
    end

    conn
      |> put_flash(String.to_atom(type), message)
      |> redirect(to: homepage_path(conn, :index))
  end
end
