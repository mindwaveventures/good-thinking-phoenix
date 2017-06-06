defmodule App.LikesController do
  use App.Web, :controller
  alias App.{Repo, Likes, Resources}
  import Phoenix.View, only: [render_to_string: 3]

  def like(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, 1
    handle_like_redirect conn, get_query_string(conn), article_id
  end

  def dislike(conn, %{"article_id" => article_id}) do
    handle_like conn, article_id, -1
    handle_like_redirect conn, get_query_string(conn), article_id
  end

  defp handle_like_redirect(conn, query, id) do
    case get_req_header(conn, "accept") do
      ["application/json"] ->
        json(conn, %{
          result: render_to_string(
            App.HomepageView,
            "resource.html",
            resource: Resources.get_single_resource(conn, id), conn: conn
          ),
          id: id
        })
      _ ->
        redirect conn, to: redirect_path(conn, query)
    end
  end

  defp handle_like(conn, article_id, like_value) do
    lm_session = get_session conn, :lm_session
    like_params = %{user_hash: lm_session,
                    article_id: String.to_integer(article_id),
                    like_value: like_value}
    changeset = Likes.changeset %Likes{}, like_params
    like = Repo.get_by Likes, article_id: article_id, user_hash: lm_session
    case like do
      nil -> Repo.insert! changeset
      %{like_value: ^like_value} -> like |> Repo.delete!
      _ -> like |> Likes.changeset(like_params) |> Repo.update!
    end
  end
  defp redirect_path(conn, query) when query == "",
    do: homepage_path conn, :index
  defp redirect_path(conn, query),
    do: homepage_path(conn, :filtered_show) <> "?" <> query
  defp get_query_string(%{req_headers: req_headers}) do
    case Enum.find req_headers, fn {key, _val} -> key == "referer" end do
      nil -> ""
      {"referer", url} -> url |> String.split("?") |> Enum.at(1, "")
    end
  end
end
