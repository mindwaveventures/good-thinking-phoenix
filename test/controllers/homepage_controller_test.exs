defmodule App.HomepageControllerTest do
  use App.ConnCase, async: false
  doctest App.HomepageController, import: true

  alias Plug.Conn
  alias App.HomepageController, as: H

  test "show redirects when issue is nonexistent", %{conn: conn} do
    params = %{"reason" => %{"reason" => "false"},
               "issue" => %{"issue" => "not_found"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 302)
  end

  test "adds suggestion", %{conn: conn} do
    params = %{"reason" => %{"add_your_own" => "snoring"},
               "issue" => %{"add_your_own" => ""},
               "content" => %{"add_your_own" => ""}}
    conn = post conn, homepage_path(conn, :show, params)

    assert get_flash(conn, :tag_suggestion)
    assert html_response(conn, 302)
  end

  test "query renders filtered content", %{conn: conn} do
    params = %{"reason" => "shift-workers",
               "issue" => "insomnia",
               "content" => ""}
    conn = get conn, homepage_path(conn, :filtered_show, params)
    assert html_response(conn, 200)
  end

  test "issues for insomnia show", %{conn: conn} do
    params = %{"reason" => %{"reason" => "false"},
               "issue" => %{"issue" => "insomnia"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 302)
  end

  @resource_id "5"
  test "/ with a like for your session", %{conn: conn} do
    params = %{"reason" => "shift-workers",
               "issue" => "insomnia",
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
    params = %{"query" => %{"q" => "SlEeP TeSt", "query_string" => "q=test&issue=insomnia"}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "search - query_string", %{conn: conn} do
    conn = get(conn, "/filter?q=sleep&issue=insomnia&content=blog&reason=")

    assert html_response(conn, 200)
    assert conn.assigns.selected_tags == []
  end

  test "search - query_string topic", %{conn: conn} do
    conn = get(conn, "/filter?q=sleep&topic=depression")

    assert html_response(conn, 200)
    assert conn.assigns.selected_tags == ["depression"]
  end

  test "search - just query", %{conn: conn} do
    conn = get(conn, "/filter?q=sleep")

    assert html_response(conn, 200)
    assert conn.assigns.selected_tags == []
  end

  test "search - topic", %{conn: conn} do
    params = %{"query" => %{"q" => ""}, "topic" => %{"anxiety" => "true", "depression" => "false"}}
    conn = post(conn, homepage_path(conn, :search, params))

    assert html_response(conn, 302)
  end

  test "query by topic filters resources", %{conn: conn} do
    params = %{"topic" => "anxiety"}
    conn = get conn, homepage_path(conn, :filtered_show, params)

    assert html_response(conn, 200)
    assert length(conn.assigns.resources) == 1
  end

  def reason_params do
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
    reason_map = %{"reason" => reason_params()}
    content_map = %{"content" => content_params()}

    assert H.create_query_string(Map.merge(reason_map, content_map)) ==
      "content=subscription"
  end
end
