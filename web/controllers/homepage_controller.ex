defmodule App.HomepageController do
  use App.Web, :controller
  alias App.{Repo, Resources, Likes, ErrorView}

  @http Application.get_env :app, :http
  @google_sheet_url_email Application.get_env :app, :google_sheet_url_email
  @google_sheet_url_suggestion Application.get_env(
    :app, :google_sheet_url_suggestion)

  def index(conn, _params) do
    session = get_session conn, :lm_session
    resources = "resource"
      |> Resources.all_query
      |> Resources.get_resources("resource", session)
      |> Resources.sort_priority

    render conn, "index.html", content: get_content(),
                 tags: get_tags(), resources: resources
  end

  def get_content do
    [:body, :footer, :alphatext, :lookingfor]
    |> Map.new(&({&1, Resources.get_content(&1)}))
  end

  def get_tags do
    [:category, :audience, :content]
    |> Map.new(&({&1, Resources.get_tags(&1)}))
  end

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

    case Resources.check_tag(tag) do
      {:error, _} ->
        conn
          |> put_status(404)
          |> render(ErrorView, "404.html")
      {:ok, _} ->
        filters = [audience, content]
          |> Enum.map(&Map.to_list/1)
          |> Enum.concat

        session = get_session conn, "lm_session"
        all_resources = Resources.get_all_filtered_resources(tag, filters, session)
        render conn, "index.html",
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

  defp handle_like(conn, article_id, like_value) do
    lm_session = get_session(conn, :lm_session)
    like_params = %{user_hash: lm_session,
                    article_id: String.to_integer(article_id),
                    like_value: like_value}
    changeset = Likes.changeset %Likes{}, IO.inspect(like_params)

    case like = Repo.get_by Likes, article_id: article_id, user_hash: lm_session do
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
