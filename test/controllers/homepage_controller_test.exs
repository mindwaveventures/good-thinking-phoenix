defmodule App.HomepageControllerTest do
  use App.ConnCase, async: false
  doctest App.HomepageController, import: true

  alias Plug.Conn

  test "show redirects when category is nonexistent", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "not_found"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 302)
  end

  test "adds suggestion", %{conn: conn} do
    params = %{"audience" => %{"add_your_own" => "snoring"},
               "category" => %{"add_your_own" => ""},
               "content" => %{"add_your_own" => ""}}
    conn = post conn, homepage_path(conn, :show, params)

    assert get_flash(conn, :tag_suggestion)
    assert html_response(conn, 302)
  end

  test "query renders filtered content", %{conn: conn} do
    params = %{"audience" => "shift-workers",
               "category" => "insomnia",
               "content" => ""}
    conn = get conn, homepage_path(conn, :filtered_show, params)
    assert html_response(conn, 200)
  end

  test "categories for insomnia show", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "insomnia"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 302)
  end

  @resource_id "5"
  test "/ with a like for your session", %{conn: conn} do
    params = %{"audience" => "shift-workers",
               "category" => "insomnia",
               "content" => ""}
    conn =
      conn
        |> Conn.put_resp_cookie("lm_session", String.duplicate("asdf", 8))
        |> post(likes_path(conn, :like, @resource_id))
        |> get(homepage_path(conn, :filtered_show, params))

    assert html_response(conn, 200)
  end
end
