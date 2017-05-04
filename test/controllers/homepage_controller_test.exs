defmodule App.HomepageControllerTest do
  use App.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

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
end
