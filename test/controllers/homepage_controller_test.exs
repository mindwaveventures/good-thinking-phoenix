defmodule App.HomepageControllerTest do
  use App.ConnCase, async: false
  doctest App.HomepageController, import: true

  alias Plug.Conn
  alias App.HomepageController, as: H

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

  test "search for tags", %{conn: conn} do
    params = %{"query" => %{"q" => "insomnia", "query_string" => ""},}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search for tags - misspelling", %{conn: conn} do
    params = %{"query" => %{"q" => "insonia", "query_string" => ""}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search for nonexistent tags", %{conn: conn} do
    params = %{"query" => %{"q" => "nonexistent", "query_string" => ""}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search for multiple words", %{conn: conn} do
    params = %{"query" => %{"q" => "sleep test", "query_string" => ""}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search - case insensitive", %{conn: conn} do
    params = %{"query" => %{"q" => "SlEeP TeSt", "query_string" => ""}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search - existing query string", %{conn: conn} do
    params = %{"query" => %{"q" => "SlEeP TeSt", "query_string" => "q=test&category=insomnia"}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search - query_string", %{conn: conn} do
    conn = get(conn, "/filter?q=sleep&category=insomnia&content=blog&audience=")

    assert html_response(conn, 200)
    assert conn.assigns.selected_tags == ["insomnia", "blog"]
  end

  test "search - just query", %{conn: conn} do
    conn = get(conn, "/filter?q=sleep")

    assert html_response(conn, 200)
    assert conn.assigns.selected_tags == []
  end

  test "search - quick_links", %{conn: conn} do
    params = %{"query" => %{"q" => ""}, "quick_links" => %{"one" => "true", "two" => "false"}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
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

  test "creating query string" do
    audience_map = %{"audience" => audience_params()}
    content_map = %{"content" => content_params()}

    assert H.create_query_string(Map.merge(audience_map, content_map)) ==
      "audience=&content=subscription"
  end

end
