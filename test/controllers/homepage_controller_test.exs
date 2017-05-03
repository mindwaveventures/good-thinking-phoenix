defmodule App.HomepageControllerTest do
  use App.ConnCase

  setup config do
    login_user(config)
  end

  @tag login_as: "me@test.com"
  test "GET / - Logged in", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

  test "GET / - Not logged in", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~ "sessions/new"
  end

  @tag login_as: "me@test.com"
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, homepage_path(conn, :index)
    assert html_response(conn, 200) =~ "sleep issues"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "not_found"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 404)
  end

  test "categories for insomnia", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "insomnia"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 200)
  end

  test "submit_email of email address", %{conn: conn} do
    params = %{"email" => %{"email" => "test@me.com"}}
    conn = post conn, homepage_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end

  test "submit_email of suggestions", %{conn: conn} do
    params = %{"suggestions" => %{"suggestions" => "suggestions"}}
    conn = post conn, homepage_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end
end
