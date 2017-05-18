defmodule App.LikesController do
  use App.Web, :controller
  alias App.{Repo, Likes}

  def like(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, 1
    handle_like_redirect conn, "Liked!", get_query_string(conn)
  end

  def dislike(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, -1
    handle_like_redirect conn, "Disliked!", get_query_string(conn)
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
  defp redirect_path(conn, query) when query == [] do
    homepage_path(conn, :index)
  end
  defp redirect_path(conn, query) do
    homepage_path(conn, :filtered_show) <> "?#{query}"
  end
  def get_query_string(conn) do
    url = case Enum.find conn.req_headers, fn {key, _val} -> key == "referer" end do
      nil -> ""
      {"referer", url} -> url
    end

    [_host | query_string] = String.split(url, "?")

    query_string
  end
end
