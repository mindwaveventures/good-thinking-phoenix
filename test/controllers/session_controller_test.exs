defmodule App.SessionControllerTest do
  use App.ConnCase

  setup config do
    login_user(config)
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert html_response(conn, 200) =~ "Username"
  end

  @tag login_as: "me@test.com"
  test "GET /sessions/new - logged in user", %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert redirected_to(conn) == homepage_path(conn, :index)
  end

  test "POST /sessions/create - success", %{conn: conn} do
    insert_user(%{username: "me", password: "secret"})
    conn = post conn, session_path(conn, :create), session: %{username: "me", password: "secret"}

    assert redirected_to(conn) == homepage_path(conn, :index)
  end

  test "POST /sessions/create - fail", %{conn: conn} do
    insert_user(%{username: "me", password: "secret"})
    conn = post conn, session_path(conn, :create), session: %{username: "me", password: "bad"}

    assert html_response(conn, 200) =~ "Invalid username/password"
  end
end
