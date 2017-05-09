defmodule App.ArticleControllerTest do
  use App.ConnCase

  setup config, do: login_user(config)

  @tag login_as: "me@test.com"
  test "GET /article/9", %{conn: conn} do
    conn = get conn, "/article/9"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

  @tag login_as: "me@test.com"
  test "GET /article/8", %{conn: conn} do
    conn = get conn, "/article/8"
    assert html_response(conn, 404)
  end
end
