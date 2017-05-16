defmodule App.ArticleControllerTest do
  use App.ConnCase

  test "GET /article/31", %{conn: conn} do
    conn = get conn, "/article/31"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

  test "GET /article/8", %{conn: conn} do
    conn = get conn, "/article/8"
    assert html_response(conn, 404)
  end
end
